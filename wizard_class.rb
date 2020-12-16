    require_relative("./player_character.rb")

    class WizardClass < PlayerCharacter
        attr_reader :name
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

        def slow_time
        end

        def to_s
            display_character
        end

    end


