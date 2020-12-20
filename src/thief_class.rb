require_relative("./player_character.rb")

class ThiefClass < PlayerCharacter
    attr_reader :name
    attr_accessor :passes, :hp
    def initialize(name)
        super(name, "thief")
        @traits[:dexterity] = self.traits[:dexterity] + 4
        @traits[:endurance] = self.traits[:endurance] - 4
        @traits.each do |key, value|
            if  @traits[key] > 20
                @traits[key] = 20
            elsif @traits[key] < 5
                @traits[key] = 5
            end
        end
        @hp = self.determine_hp(@traits[:endurance])
        @passes = self.determine_passes(@traits[:intelligence])
        @changes = self.determine_changes(@traits[:dexterity])
        # puts "Traits within ThiefClass #{@traits}"
        # puts "Character HP #{@hp}"
        # puts "Character passes #{@passes}"
        # puts "Character changes #{@changes}"
        @powers = 1
    end

    def random_word
        random_word = $current_lvl.fetch(rand($current_lvl.length-1))
    end
        
    def power
        if @powers > 0
            puts "#{name} used the character SNEAKY PEEK power!"
            choices = [$current_word, random_word, random_word]
            user_diff = $prompt.select("Choose the word from the list below:", choices.shuffle!)
            @powers -= 1
        else
            puts "You've already used your power!"
            try_again
        end
    end
    
    def to_s
        display_character
    end
end
