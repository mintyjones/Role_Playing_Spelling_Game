# Spelling Game
# all required files and gems
require_relative("./barbarian_class.rb")
require_relative("./wizard_class.rb")
require_relative("./thief_class.rb")
require_relative("./high_scores.rb")
require_relative("./instructions.rb")
require "tty-table"
require "time"
require "colorize"
require "tty-prompt"
require "tty-font"
require "yaml"
require 'timeout'


# Display the starting game menu and check for command line arguments
def display_menu
    font_sml = TTY::Font.new(:straight)
    font_big = TTY::Font.new(:doom)
    font_col = Pastel.new
    system "clear"
    # if statement to detect if arguments given in command line
    if ARGV.length == 1
        puts font_sml.write("#{ARGV[0]}, Welcome to...") 
        ARGV.clear
    elsif ARGV.length > 1 && ARGV[1] == "-s"
        puts font_sml.write("#{ARGV[0]}, Welcome to...") 
        ARGV.clear
        random_character
        pre-game
    else
        puts font_sml.write("Welcome to...")
    end
    puts font_col.red(font_big.write("RPSG"))
    puts "If you haven't played before, it is advisable to read the instructions."
    # displays game menu to player
    return $prompt.select("What would you like to do?",
        ["Start New Game", "View Instructions", "View Leaderboard", "Exit Game"])
end

# Create character and set the character class and name
def make_character
    system "clear"
    font_big = TTY::Font.new(:doom)
    font_col = Pastel.new
    puts font_col.red(font_big.write("Character Creation"))
    puts "Create a new character!"
    user_character = $prompt.select("What character class would you like to choose?", ["Barbarian", "Wizard", "Thief", "Random"])
    if user_character != "Random"
        puts "Enter character name: "
        char_name = gets.chomp
    end
    # Error check if player doesn't enter any name
    while char_name == ""
        puts "Please enter a name:"
        char_name = gets.chomp
    end
    case user_character
    when "Barbarian"
        new_player = BarbarianClass.new(char_name)
    when "Wizard"
        new_player = WizardClass.new(char_name)
    when "Thief"
        new_player = ThiefClass.new(char_name)
    else
        random_character
    end
    character_check(new_player)
end

# prompt to user to check if happy with this character
def character_check(character)
    system "clear"
    puts character
    user_happy = $prompt.select("Are you happy with this character?", ["Yes", "No"])
    if user_happy == "Yes"
        $player = character
        pick_difficulty
    else
        sleep(1)
        make_character
    end
end

# Creates a random class of character with a set name
def random_character
    rand_char_num = rand(1..3)
    case rand_char_num
    when 1
        new_player = WizardClass.new("Gandalf")
    when 2
        new_player = BarbarianClass.new("Conan")
    when 3
        new_player = ThiefClass.new("Arthur")
    end
    character_check(new_player)
end

# Gives a puase to the player before they start the game
def pre_game
    puts 
    puts "Get ready for the Horde - Level 1...."
    puts "Press enter when you're ready..."
    gets
    display_word
end

#sets the difficulty of the game
def pick_difficulty
    user_diff = $prompt.select("Pick a difficulty level", ["Easy", "Medium", "Hard"])
    case user_diff
    when "Easy"
        $hide_speed = 3  
        $time_limit = 7
    when "Medium"
        $hide_speed = 2
        $time_limit = 6
    when "Hard"
        $hide_speed = 1.5
        $time_limit = 5
    end 
    pre_game
end

# displays the current level above the game screens
def wave_display
    font_big = TTY::Font.new(:doom)
    font_col = Pastel.new
    case $current_lvl
    when $lvl_1
        puts font_col.red(font_big.write("WAVE 1"))
    when $lvl_2
        puts font_col.red(font_big.write("WAVE 2"))
    when $lvl_3
        puts font_col.red(font_big.write("WAVE 3"))
    end
end

# displays the current word on the screen for a specified amount of time
def display_word
    system "clear"
    wave_display
    puts "Watch carefully and remember..."
    puts " " + fetch_current_word + " \r"
    # time_limit
    sleep($hide_speed)
    player_input_word
end

# allows the player to input their word with a time limit imposed
def player_input_word
    system "clear"
    wave_display
    puts "#{$no_of_enemies-$word_count} remain to be defeated!".black.on_green
    puts "You have #{$time_limit} seconds to destroy the minion:".red.blink
    begin
    start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    player_attempt = Timeout::timeout($time_limit) {
        printf "Input: "
        gets.chomp
    }
    end_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    time_passed = end_time - start_time
    # puts "Got: #{status}"
    rescue Timeout::Error
    puts "\nInput timed out after #{$time_limit} seconds"
    end
    match_check(player_attempt, time_passed)
end

# randomly selects a word from the currnet level's word pool
def fetch_current_word
    $current_word = $current_lvl.fetch(rand($current_lvl.length-1))
    $current_word.colorize(:color => :black, :background => :green)
end

# checks if word entered is correct, or if the player has used a special ability
def match_check(enteredWord, time)
    if enteredWord == $current_word
        $word_count += 1
        # congratulate
        puts "Well done - that is correct"
        # delete word
        $current_lvl.delete($current_word)
        update_score(time)
        puts "Your current score: #{$player_score}"
        sleep(3)
        next_level_check    
    elsif enteredWord == ""
        if $player.passes > 0
            $word_count += 1
            puts "You have used a pass power!!"
            $used_passes += 1
            $player.passes -= 1
            puts "You have #{$player.passes} left!"
            sleep(2)
            next_level_check 
        else
            puts "You have no passes left!"
            puts "You have lost a life."
            $player.hp -= 1
            # check if alive or dead
            game_over_check
        end
    elsif enteredWord == "1"
        # $player.class
        if $player.class == ThiefClass
            thief_guess = $player.power
            match_check(thief_guess, time)
        end
        $player.power
        if $player.hp < 1
            game_over_check
        else
            next_level_check
        end
    else
        # indicate wrong answer
        system "clear"
        puts "Oh dear, enemy gets a hit in."
        # decrease lives by one
        $player.hp -= 1
        # check if alive or dead
       game_over_check
    end
end

# updates the player's score according to how fast they entered the word
# need to look if I can make these ranges more dynamic regarding diff level
def update_score(time)
    case time
    when 0..2.5
        $player_score += 3
    when 2.6..4.5
        $player_score += 2
    when 4.6..7
        $player_score += 1
    end
end

# checks how many words the player has entered correctly and decides if we move onto the next level
def next_level_check
    if ($current_lvl == $lvl_1 && $word_count > 9) || ($current_lvl == $lvl_2 && $word_count > 14) || ($current_lvl == $lvl_3 && $word_count > 19)
        $word_count = 0
        system "clear"
        level_advance
    else
        # if so display the next word
        system "clear"
        next_word()
    end
end

# runs when a player loses a life checks if they are out of lives and if the game is over
# if they have lives left, they get to retry the current word
def game_over_check
    if $player.hp > 0
        # allow retry  
        puts "You have #{$player.hp} lives left!"
        sleep(2.5)
        system "clear"
        puts "Try again"
        try_again
    else
        puts "GAME OVER!!!!! :("
        puts "Final score: #{$player_score}"
        # puts $player.class
        high_score = Hash.new{0}
        high_score[:playername] = $player.name
        high_score[:playerscore] = $player_score
        write_to_file(high_score)
        retry_game
    end
end

# user prompt to progress to the next wave
def continue
    print "Press enter to face the next wave"
    gets
end

# gives the player anopportunity to try the current word again
def try_again
    wave_display
    puts "Here's the word again..."
	puts $current_word.colorize(:color => :black, :background => :green) + "\r"
    sleep($hide_speed)
    player_input_word
end

#wsrites the player's score to locally scored YAML file
def write_to_file(high_score)
    file = File.open("data/highscores.yml","a+"){ |file| file.write(high_score.to_yaml)}
end

# def validate_scores

# Screen message to who next word is being displayed
def next_word
    puts "Here's the next enemy..."
    display_word
end

# moves the game to the next level state increasing the amount of enemies, and decreasing hide speeds and time limits
def level_advance
    all_lvls = [$lvl_1, $lvl_2, $lvl_3]
    if $current_lvl != all_lvls.last
        puts "You hve defeated the first wave - prepare for wave #{$level_counter + 2}!"
        puts "Here's a reminder of your character's stats"
        # the hp is not correct here.
        puts $player
        $level_counter += 1
        $no_of_enemies += 5
        $current_lvl = all_lvls[$level_counter]
        if $hide_speed >= 0.4
            $hide_speed -= 0.2
        end
        if $time_limit >= 3
            $time_limit -= 2
        end
        continue()
        system "clear"
        next_word()
    else
        puts "Congratulations!! You have BEATEN THE GAME!!"
        retry_game
    end
end

# prompt to ask the user if they want to try the game again
def retry_game
    user_retry = $prompt.select("Would you like to try again?", ["Yes", "No"])
    if user_retry == "Yes"
        reset_vars
        start_app
    else
        puts "Come back to fight another day..."
    end
end

# this resets all the varisbale in the event that the player restarts the game
def reset_vars
    $lvl_1 = ["foodless", "attained", "auspices", "thriving", "charters", "spiffier", "styrenes", "singlets", "timbrels", "hidalgos", "tentacle", "sufficed", "deaconed", "peacocks", "beshamed", "tapeless", "goldeyes", "gavelled", "pinkness", "nonfatal", "citrated", "outscorn", "warpwise", "adjoined", "stifling", "oosperms", "innately", "prunable", "imploded", "overstir", "opposite", "automata", "whomever", "skewbald", "premolds", "goombays", "freakily", "deadwood", "savaging", "hereaway", "wabblers", "hazarded", "bowering", "pastrami", "seraglio", "unquotes", "cymosely", "sunbaked", "petering", "eeriness"]
    $lvl_2 = ["criticism", "incapable", "frequency", "strategic", "agreement", "direction", "modernize", "leftovers", "candidate", "secretary", "operation", "reception", "craftsman", "colleague", "conductor", "intensify", "dimension", "permanent", "disappear", "radiation", "objective", "education", "paragraph", "ambiguous", "discovery", "butterfly", "authorise", "neighbour", "coalition", "overwhelm", "exception", "represent", "hilarious", "recommend", "housewife", "reconcile", "committee", "attention", "earthflax", "available", "underline", "extension", "favorable", "encourage", "community", "effective", "depressed", "admission", "adventure", "talkative"]
    $lvl_3 = ["negligence", "goalkeeper", "proportion", "opposition", "articulate", "literature", "retirement", "commitment", "provincial", "profession", "acceptance", "settlement", "girlfriend", "excitement", "incredible", "reputation", "prediction", "difference", "dictionary", "repetition", "helicopter", "withdrawal", "projection", "accountant", "overcharge", "substitute", "psychology", "unpleasant", "deficiency", "conclusion", "perception", "correction", "acceptable", "philosophy", "gregarious", "relinquish", "houseplant", "confidence", "reasonable", "tournament", "depression", "presidency", "background", "hypothesis", "foundation", "redundancy", "experiment", "correspond", "restaurant", "enthusiasm"]
    # $lvl_3 = ["hatchability", "interdetermination", "thunderclap"]
    $current_word = ""
    player_attempt = ""
    $player_score = 0
    $level_counter = 0
    $word_count = 0
    $current_lvl = $lvl_1
    $hide_speed = 1.5
    $time_limit = 7
    $no_of_enemies = 10
    $used_passes = 0
    $prompt = TTY::Prompt.new
    $player = nil
end

# game_start
def start_app
    reset_vars
    user_choice = ""
    while user_choice != "Exit Game"
        user_choice = display_menu
        case user_choice
        when "Start New Game"
            make_character
            break
        when "View Instructions"
            puts Instructions.new
            puts "Press Enter to return to main menu."
            gets
            start_app
            break
        when "View Leaderboard"
            puts HighScores.new
            puts "Press Enter to return to main menu."
            gets
            start_app
            break
        else
            puts "Come back again soon....if you DARE!!!"
            break
        end
    end
end

start_app