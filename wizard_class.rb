    require_relative("./player_character.rb")

    class WizardClass < PlayerCharacter
        attr_reader :name
        attr_accessor :passes, :hp
        def initialize(name)
            super(name, "wizard")
            @traits[:intelligence] = traits[:intelligence] + 4
            @traits[:endurance] = traits[:endurance] - 3
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
            puts "#{name} used the character SLOW TIME power!"
            puts "Everything is in slow motion!"
            $hide_speed *= 2
            @traits[:intelligence] -= 5
            @passes = determine_passes(@traits[:intelligence]) - 1
            if $used_passes < @passes
                @passes -= $used_passes
            end
            sleep(3)
        end

        def to_s
            display_character
        end

    end


