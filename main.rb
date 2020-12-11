# Spelling Game
require_relative("./player_character.rb")

require "time"
require "colorize"
require "tty-prompt"
require "tty-font"

# all level word arrays
$lvl_1 = ["sapphic", "polysemous", "tricostate", "dissimilate", "fatherly", "perimeter", "decalogue", "moulage", "polygamy", "hipponous", "unsettledness", "selah", "galen", "tilt", "sheepshead", "venezuela", "nonbureaucratically", "mushier", "ruyter", "outdrove", "tablinum", "intestinally", "populous", "hardware", "lunacy", "estonian", "clementine", "unprotuberant", "bronchus"]
# $lvl_1 = ["perimeter"]
$lvl_2 = ["semimatt", "incarnalising", "reno", "relanced", "preconsent", "cunnilinctus", "nonperpetration", "antierosive", "nonlimitative", "roster", "deuteron", "exurb", "surfbird", "jennet", "confessionalism", "ascribing", "branchiopodous", "aurelian", "unstinting", "intersentimental", "chemism", "moebius", "savourier", "panheaded", "unclipper", "minipill", "codling", "mesnalty", "calfless"]
# $lvl_2 = ["balanced", "uncertain"]
$lvl_3 = ["hatchability", "riempie", "bruit", "unportended", "benzotrifluoride", "unsaltatorial", "interdetermination", "graze", "crystallographer", "harpins", "thunderclap", "macrocyte", "ennoblement", "demonetise", "unclustered", "piddler", "ceremonious", "lenore", "toweled", "finitude", "jemima", "nondegenerate", "levallois", "nomenclature", "davina", "eaves", "faintheartedly", "unweened", "reproachless"]
# $lvl_3 = ["hatchability", "interdetermination", "thunderclap"]



$current_word = ""
player_attempt = ""
$player_lives = 3
$player_score = 0
$level_counter = 0
$current_lvl = $lvl_1
$hide_speed = 1.5
$retry = false
$prompt = TTY::Prompt.new

def game_start
    font_sml = TTY::Font.new(:straight)
    font_big = TTY::Font.new(:doom)
    font_col = Pastel.new
    system "clear"
    puts font_sml.write("Welcome to...")
    puts font_col.red(font_big.write("RPSG"))
    return $prompt.select("What would you like to do?",
        ["Start New Game", "View Instructions", "Exit Game"])
end

def random_character
    all_chars=["barbarian", "wizard", "thief"]
    rand_char_num = rand(1..3)
    new_player = PlayerCharacter.new("a_player", 3, all_chars[rand_char_num-1])
end


# def startup() 
#     system "clear"
#     if $retry == false
#         # returns the player's first attempt at the first word
#         puts "Think your gud at speling?"
#         sleep(2)
#         puts "I'll displae a wurd, and then tayk it away...you have to then remember and type it."
#         sleep(3)
#         puts ""
#         puts "If yoo get it right, I'll displae anuther werd and yoo doo the same."
#         sleep(2.5)
#         puts "If you get it rong, youll looz a life and have too try again."
#         puts ""
#         sleep(2)
#     else
#         puts "You know the rules...!"
#     end
    
#     print "Pick a difficulty level (easy/med/hard): "
#     diff_choice = gets.chomp
#     case diff_choice
#         when "easy"
#             $hide_speed = 3  
#         when "med"
#             $hide_speed = 2
#         when "hard"
#             $hide_speed = 1.5
#     end 
#     continue
#     system "clear"
#     puts "Here's the first word"
#     display_word
# end

def display_word()
    puts fetch_current_word + "\r"
    # time_limit
    # $stdout.flush
    sleep($hide_speed)
    system "clear"
    puts "pleez type the word:"
    player_attempt = gets.chomp
    match_check(player_attempt)
end

def fetch_current_word()
    $current_word = $current_lvl.fetch(rand($current_lvl.length-1))
    $current_word.colorize(:color => :light_blue, :background => :red)
end

def time_limit()
    second_limit = 5
    start_time = Time.now.to_i
    current_time = Time.now.to_i
    while current_time < start_time + second_limit
        puts "Timer #{current_time}"
        current_time = Time.now.to_i
    end
end



def match_check(enteredWord)
    if enteredWord == $current_word
        # congratulate
        puts "Well done - that is correct"
        $player_score += 1
        puts "Your current score: #{$player_score}"
        sleep(3)
        # delete word
        $current_lvl.delete($current_word)
        # check if any words left in the ar
        if $current_lvl.length > 0
            # if so  display the next word
            system "clear"
            next_word()
        else
            # display level up message
            # puts "You are soooo gud - you're on to level #{$level_counter + 2}!"
            # wait for user repsonse
            # continue()
            # increment the level
            system "clear"
            level_advance
        end
    else
        # indicate wrong answer
        system "clear"
        puts "Bah bah - wrong."
        # decrease lives by one
        $player_lives -= 1
        # check if alive or dead
        if $player_lives > 0
            # allow retry  
            puts "You have #{$player_lives} lives left!"
            sleep(2.5)
            system "clear"
            puts "Try again"
            try_again
        else
            puts "GAME OVER!!!!! :("
            puts "Final score: #{$player_score}"
            retry_game
        end
    end
end

def continue()
    print "Press enter wen yoo reddy"
    gets
end

def try_again()
    puts "Here's the word again..."
	puts $current_word.colorize(:color => :light_blue, :background => :red) + "\r"
    $stdout.flush
    sleep($hide_speed)
    system "clear"
    puts "pleez type the word:"
    player_attempt = gets.chomp
    match_check(player_attempt)
end

def reset_vars()
    $lvl_1 = ["sapphic", "polysemous", "tricostate", "dissimilate", "fatherly", "perimeter", "decalogue", "moulage", "polygamy", "hipponous", "unsettledness", "selah", "galen", "tilt", "sheepshead", "venezuela", "nonbureaucratically", "mushier", "ruyter", "outdrove", "tablinum", "intestinally", "populous", "hardware", "lunacy", "estonian", "clementine", "unprotuberant", "bronchus"]
    # $lvl_1 = ["perimeter"]
    $lvl_2 = ["semimatt", "incarnalising", "reno", "relanced", "preconsent", "cunnilinctus", "nonperpetration", "antierosive", "nonlimitative", "roster", "deuteron", "exurb", "surfbird", "jennet", "confessionalism", "ascribing", "branchiopodous", "aurelian", "unstinting", "intersentimental", "chemism", "moebius", "savourier", "panheaded", "unclipper", "minipill", "codling", "mesnalty", "calfless"]
    # $lvl_2 = ["balanced", "uncertain"]
    $lvl_3 = ["hatchability", "riempie", "bruit", "unportended", "benzotrifluoride", "unsaltatorial", "interdetermination", "graze", "crystallographer", "harpins", "thunderclap", "macrocyte", "ennoblement", "demonetise", "unclustered", "piddler", "ceremonious", "lenore", "toweled", "finitude", "jemima", "nondegenerate", "levallois", "nomenclature", "davina", "eaves", "faintheartedly", "unweened", "reproachless"]
    # $lvl_3 = ["hatchability", "interdetermination", "thunderclap"]
    $current_word = ""
    player_attempt = ""
    $player_lives = 3
    $level_counter = 0
    $player_score = 0
    $current_lvl = $lvl_1
    $hide_speed = 1.5
    $retry = false
end

def next_word()
    puts "Here's your next word..."
    display_word
end

def level_advance()
    all_lvls = [$lvl_1, $lvl_2, $lvl_3]
    if $current_lvl != all_lvls.last
        puts "You are soooo gud - you're on to level #{$level_counter + 2}!"
        $level_counter += 1
        $current_lvl = all_lvls[$level_counter]
        if $hide_speed >= 0.4
            $hide_speed -= 0.2
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
        startup
    else
        puts "Cya later..."
    end
end

# game_start

user_choice = ""
while user_choice != "Exit Game"
    user_choice = game_start
    case user_choice
    when "Start New Game"
        puts random_character
        break
    when "View Instructions"
        "sds"
    else
        puts "Come back again soon....if you DARE!!!"
        next
    end
end

puts random_character.traits
