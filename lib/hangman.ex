defmodule Hangman do
    def init do
        Agent.start_link(fn-> %{} end, name: Game)
        Agent.start_link(fn-> %{} end, name: GG)
        get_word
    end
    def put(key, value) do
        Agent.update(Game , &Map.put(&1, key, value))
    end
    def store_good(key, value) do
        Agent.update(GG , &Map.put(&1, key, value))
    end
    def listy do
        Agent.get(Game, &Map.values(&1))
    end
    def g_g do
        Agent.get(GG, &Map.values(&1))
    end

    def get_word do
        wd = IO.gets("Select word: ") 
        word = String.trim(wd)
        cond do
            String.length(word) < 1 ->
                get_word
            true ->
                IO.puts "loading game..."
                Process.sleep(2000)
                start_game(word)
        end
    end
    def start_game(word) do
        len = String.length(word)
        slots = String.duplicate("_ ", len)
        IO.puts "The word is: " <> slots <> " "
        guess_word(word, len - 1+4)
    
        Agent.stop(Game)
        Agent.stop(GG)
    end

    def guess_word(word, duration) do 
        gs = IO.gets("enter letter: ") 
        guess = String.trim(gs)
        put(duration, guess)
        update_letters()
        check_match(word, guess, duration)
        IO.puts "Body parts remaining " <> Integer.to_string(duration)
        if duration > 0 && !check_win(word, guess) && String.length(ret) != String.length(word) do
            guess_word(word, duration - 1)
        end
        
    end
    def check_match(word, guess, duration) do
        len = String.length(word)
        str = String.duplicate("_", len)
        if String.contains? word, guess do 
            store_good(duration, guess)
            {index, _} = :binary.match(word, guess)
            IO.puts String.slice(str, index, len) <> String.reverse(ret) <> String.slice(str, index+1, len) <> " "
            IO.puts "Good guess!"
        else
            IO.puts "Too bad. Nice try!"
        end
    end
    def check_win(word, guess) do
        if String.length(guess) > 1 do
            if String.equivalent?(word, guess) do
                IO.puts "First try!!!"
            else 
            end
        end
    end
    def update_letters do
        str = List.to_string(listy)
        IO.puts "letters: " <> String.reverse(str) <> " "
    end
    def ret do
        List.to_string(g_g)
    end
    #buggy -> need to fix
    def display_results(word, duration)do
          cond do 
            String.length(ret) == String.length(word) ->
                "You win...The word was " <> word
            duration == 0 ->
                "You lose...The word was " <> word
            duration > 0 ->
                "Body parts remaining " <> Integer.to_string(duration)
        end
    end
end
