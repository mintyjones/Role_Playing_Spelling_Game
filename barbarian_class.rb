require_relative("./player_character.rb")

class BarbarianClass < PlayerCharacter
    attr_reader :name
    attr_accessor :passes, :hp
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
    end

    def power
        puts "#{name} used the character BIG STRIKE power!"
        puts "You have destroyed half of this wave!"
        $word_count += $no_of_enemies/2
        @hp -= 2
        sleep(3)
    end
    
    def to_s
        display_character
    end

end