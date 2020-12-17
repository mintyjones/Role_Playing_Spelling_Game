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
    end

    def power
        puts "Using the character power"
    end
    
    def to_s
        display_character
    end
end
