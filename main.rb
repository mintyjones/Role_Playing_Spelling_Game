# Spelling Game
require_relative("./barbarian_class.rb")
require_relative("./wizard_class.rb")
require_relative("./thief_class.rb")
require_relative("./high_scores.rb")
require_relative("./GetKey.rb")
require "tty-table"
require "time"
require "colorize"
require "tty-prompt"
require "tty-font"
# require "tty-progressbar"
# require "gosu"
# require "tty-spinner"
require "yaml"
# require 'io/console'

require 'timeout'

# all level word arrays
$lvl_1 = ["foodless", "attained", "auspices", "thriving", "charters", "spiffier", "styrenes", "singlets", "timbrels", "hidalgos", "tentacle", "sufficed", "deaconed", "peacocks", "beshamed", "tapeless", "goldeyes", "gavelled", "pinkness", "nonfatal", "citrated", "outscorn", "warpwise", "adjoined", "stifling", "oosperms", "innately", "prunable", "imploded", "overstir", "opposite", "automata", "whomever", "skewbald", "premolds", "goombays", "freakily", "deadwood", "savaging", "hereaway", "wabblers", "hazarded", "bowering", "pastrami", "seraglio", "unquotes", "cymosely", "sunbaked", "petering", "eeriness"]

$lvl_2 = ["criticism", "incapable", "frequency", "strategic", "agreement", "direction", "modernize", "leftovers", "candidate", "secretary", "operation", "reception", "craftsman", "colleague", "conductor", "intensify", "dimension", "permanent", "disappear", "radiation", "objective", "education", "paragraph", "ambiguous", "discovery", "butterfly", "authorise", "neighbour", "coalition", "overwhelm", "exception", "represent", "hilarious", "recommend", "housewife", "reconcile", "committee", "attention", "earthflax", "available", "underline", "extension", "favorable", "encourage", "community", "effective", "depressed", "admission", "adventure", "talkative"]

$lvl_3 = ["negligence", "goalkeeper", "proportion", "opposition", "articulate", "literature", "retirement", "commitment", "provincial", "profession", "acceptance", "settlement", "girlfriend", "excitement", "incredible", "reputation", "prediction", "difference", "dictionary", "repetition", "helicopter", "withdrawal", "projection", "accountant", "overcharge", "substitute", "psychology", "unpleasant", "deficiency", "conclusion", "perception", "correction", "acceptable", "philosophy", "gregarious", "relinquish", "houseplant", "confidence", "reasonable", "tournament", "depression", "presidency", "background", "hypothesis", "foundation", "redundancy", "experiment", "correspond", "restaurant", "enthusiasm"]



$current_word = ""
player_attempt = ""
$player_score = 0
$level_counter = 0
$word_count = 0
$current_lvl = $lvl_1
$hide_speed = 1.5
$time_limit = 7
$retry = false
# SHOULD I USE THIS AS A GLOBAL VARIABLE?
$prompt = TTY::Prompt.new
$player = nil

def display_menu
    font_sml = TTY::Font.new(:straight)
    font_big = TTY::Font.new(:doom)
    font_col = Pastel.new
    system "clear"
    puts font_sml.write("Welcome to...")
    puts font_col.red(font_big.write("RPSG"))
    return $prompt.select("What would you like to do?",
        ["Start New Game", "View Instructions", "View Leaderboard", "Exit Game"])
end

def make_character
    puts "Create a new character!"
    user_character = $prompt.select("What character class would you like to choose?", ["Barbarian", "Wizard", "Thief", "Random"])
    case user_character
    when "Barbarian"
        puts "Enter character name: "
        char_name = gets.chomp
        new_player = BarbarianClass.new(char_name)
    when "Wizard"
        puts "Enter character name: "
        char_name = gets.chomp
        new_player = WizardClass.new(char_name)
    when "Thief"
        puts "Enter character name: "
        char_name = gets.chomp
        new_player = ThiefClass.new(char_name)
    else
        random_character
    end
    character_check(new_player)
end

def character_check(character)
    system "clear"
    puts character
    puts "Are you happy with this character? (y/n)"
    user_reply = gets.chomp
    if user_reply == "y"
        $player = character
        pick_difficulty
    else
        puts "Press enter to reroll character..."
        gets
        make_character
    end
end

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

def pre_game
    puts 
    puts "Get ready for the Horde - Level 1...."
    puts "Press enter when you're ready..."
    gets
    display_word
end

def pick_difficulty
    print "Pick a difficulty level (easy/med/hard): "
    diff_choice = gets.chomp
    case diff_choice
        when "easy"
            $hide_speed = 3  
            $time_limit = 7
        when "med"
            $hide_speed = 2
            $time_limit = 6
        when "hard"
            $hide_speed = 1.5
            $time_limit = 5
    end 
    pre_game
end

def display_word
    system "clear"
    puts "Watch carefully and remember..."
    puts " " + fetch_current_word + " \r"
    # time_limit
    sleep($hide_speed)
    system "clear"
    puts "You have #{$time_limit} seconds to destroy the minion:"
    begin
    #run_special
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

def fetch_current_word()
    $current_word = $current_lvl.fetch(rand($current_lvl.length-1))
    $current_word.colorize(:color => :black, :background => :green)
end

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
            $player.passes -= 1
            puts "You have #{$player.passes} left!"
            sleep(2)
            next_level_check 
        else
            puts "You have no passes left!"
            $player.hp -= 1
            # check if alive or dead
            game_over_check
        end
    elsif enteredWord == "1"
        $player.power
        game_over_check
    else
        # indicate wrong answer
        system "clear"
        puts "Bah bah - wrong."
        # decrease lives by one
        $player.hp -= 1
        # check if alive or dead
        game_over_check
    end
end

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

def continue
    print "Press enter wen yoo reddy"
    gets
end

def try_again
    puts "Here's the word again..."
	puts $current_word.colorize(:color => :black, :background => :green) + "\r"
    sleep($hide_speed)
    system "clear"
    puts "You have #{$time_limit} seconds to destroy the minion:"
    
    x = $time_limit
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
    puts "\nInput timed out after #{x} seconds"
    end
    match_check(player_attempt, time_passed)
end

def write_to_file(high_score)
    # Here is a scenario where we try to search for a file to open it and write to it
    #  this begin rescue block ensures that if there is an error while during the file open / write operation in the BEGIN block, it is handled in the rescue block
    begin
        # This is a behaviour that mimicks storing data to a DB - for now its just a file that we are dealing with
        file = File.open("highscores.yml","a+"){ |file| file.write(high_score.to_yaml)}
        if file
            # puts "High score saved successfully to file"
        end
    rescue
        puts "File not found"
        puts "Could not save high score to the file"
    end
end

def next_word
    puts "Here's the next enemy..."
    display_word
end

def level_advance
    all_lvls = [$lvl_1, $lvl_2, $lvl_3]
    if $current_lvl != all_lvls.last
        puts "You hve defeated the first wave - prepare for wavel #{$level_counter + 2}!"
        puts "Here's a reminder of your character's stats"
        # the hp is not correct here.
        puts $player
        $level_counter += 1
        $current_lvl = all_lvls[$level_counter]
        if $hide_speed >= 0.4
            $hide_speed -= 0.2
        end
        if $time_limit >= 2
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

def retry_game()
    print "Would you like to try again? (y/n) "
    go_again = gets.chomp
    if go_again == "y"
        reset_vars

        $retry = true
        display_menu
    else
        puts "Cya later..."
    end
end

def reset_vars()
    $lvl_1 = ["foodless", "attained", "auspices", "thriving", "charters", "spiffier", "styrenes", "singlets", "timbrels", "hidalgos", "tentacle", "sufficed", "deaconed", "peacocks", "beshamed", "tapeless", "goldeyes", "gavelled", "pinkness", "nonfatal", "citrated", "outscorn", "warpwise", "adjoined", "stifling", "oosperms", "innately", "prunable", "imploded", "overstir", "opposite", "automata", "whomever", "skewbald", "premolds", "goombays", "freakily", "deadwood", "savaging", "hereaway", "wabblers", "hazarded", "bowering", "pastrami", "seraglio", "unquotes", "cymosely", "sunbaked", "petering", "eeriness"]
    # $lvl_1 = ["perimeter"]
    $lvl_2 = ["criticism", "incapable", "frequency", "strategic", "agreement", "direction", "modernize", "leftovers", "candidate", "secretary", "operation", "reception", "craftsman", "colleague", "conductor", "intensify", "dimension", "permanent", "disappear", "radiation", "objective", "education", "paragraph", "ambiguous", "discovery", "butterfly", "authorise", "neighbour", "coalition", "overwhelm", "exception", "represent", "hilarious", "recommend", "housewife", "reconcile", "committee", "attention", "earthflax", "available", "underline", "extension", "favorable", "encourage", "community", "effective", "depressed", "admission", "adventure", "talkative"]
    # $lvl_2 = ["balanced", "uncertain"]
    $lvl_3 = ["negligence", "goalkeeper", "proportion", "opposition", "articulate", "literature", "retirement", "commitment", "provincial", "profession", "acceptance", "settlement", "girlfriend", "excitement", "incredible", "reputation", "prediction", "difference", "dictionary", "repetition", "helicopter", "withdrawal", "projection", "accountant", "overcharge", "substitute", "psychology", "unpleasant", "deficiency", "conclusion", "perception", "correction", "acceptable", "philosophy", "gregarious", "relinquish", "houseplant", "confidence", "reasonable", "tournament", "depression", "presidency", "background", "hypothesis", "foundation", "redundancy", "experiment", "correspond", "restaurant", "enthusiasm"]
    # $lvl_3 = ["hatchability", "interdetermination", "thunderclap"]
    $current_word = ""
    player_attempt = ""
    $level_counter = 0
    $player_score = 0
    $current_lvl = $lvl_1
    $hide_speed = 1.5
    $retry = false
    $player = nil
    user_choice = ""
end

# game_start

user_choice = ""
while user_choice != "Exit Game"
    user_choice = display_menu
    case user_choice
    when "Start New Game"
        make_character
        break
    when "View Instructions"
        puts "sds"
    when "View Leaderboard"
        puts HighScores.new
        puts "Press Enter to return to main menu."
        gets
        display_menu
        next
    else
        puts "Come back again soon....if you DARE!!!"
        next
    end
end

# puts random_character.traits
