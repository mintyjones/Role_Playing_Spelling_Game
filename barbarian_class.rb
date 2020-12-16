require_relative("./player_character.rb")

class BarbarianClass < PlayerCharacter
    attr_reader :name, :hp
    attr_accessor :passes
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

    def power
        puts "Using the character power"
        case $current_lvl
        when $lvl_1
            $word_count += 5
        when $lvl_2
            $word_count += 7
        when $lvl_3
            $word_count += 10
        end
        $player_lives -= 2
    end
    
    def to_s
        display_character
    end

end