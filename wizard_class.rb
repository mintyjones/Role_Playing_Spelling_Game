    require_relative("./player_character.rb")

    class WizardClass < PlayerCharacter
        attr_reader :name
        attr_accessor :passes, :hp
        def initialize(name)
            super(name, "wizard")
            @traits[:intelligence] = self.traits[:intelligence] + 4
            @traits[:endurance] = self.traits[:endurance] - 3
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
            # puts "Traits within WizardClass #{@traits}"
            # puts "Character HP #{@hp}"
            # puts "Character passes #{@passes}"
            # puts "Character changes #{@changes}"
        end

        def power
            puts "Using the character SLOW TIME power!"
            puts "Everything is in slow motion!"
            $hide_speed *= 2
            @traits[:intelligence] -= 4
            @passes = determine_passes(@traits[:intelligence]) - 1
            sleep(3)
        end

        def to_s
            display_character
        end

    end


