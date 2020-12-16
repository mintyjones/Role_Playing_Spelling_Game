require_relative("./player_character.rb")

class BarbarianClass < PlayerCharacter
    attr_reader :name
    def initialize(name)
        super(name, "barbarian")
        @traits[:intelligence] = traits[:intelligence] - 3
        @traits[:endurance] = traits[:endurance] + 4
        # Make sure traits are capped at 20 and floored at 5
        @traits.each do |key, value|
            if  @traits[key] > 20
                @traits[key] = 20
            elsif @traits[key] < 5
                @traits[key] = 5
            end
        end
        @hp = determine_hp(@traits[:endurance])
        @passes = determine_passes(@traits[:intelligence])
        @changes = determine_changes(@traits[:dexterity])
        # puts "Traits within BarbarianClass #{@traits}"
        # puts "Character HP #{@hp}"
        # puts "Character passes #{@passes}"
        # puts "Character changes #{@changes}"
    end

    def big_strike
    end
    
    def to_s
        display_character
    end

end