class PlayerCharacter
    attr_reader :traits
    def initialize(name, character_class)
        @name = name
        @character_class = character_class
        @traits = Hash.new{}
        @traits[:endurance] = rand(5..20)
        @traits[:intelligence] = rand(5..20)
        @traits[:dexterity] = rand(5..20)
        # puts "Initial traits: #{@traits}"
    end

    # it would be nice to convert the 3 following methods into one called determiner which could accept a trait and an array of ranges as arguments

    def determine_hp(endurance)
        hp = 0
        case endurance
        when 5..9
            hp = 2
        when 10..15
            hp = 3
        when 16..20
            hp = 4
        end
        hp   
    end

    def determine_passes(intelligence)
        passes = 0
        case intelligence
        when 5..10
            passes = 0
        when 11..17
            passes = 1
        when 18..20
            passes = 2
        end
        passes   
    end

    def determine_changes(dexterity)
        changes = 0
        case dexterity
        when 5..10
            changes = 1
        when 11..17
            changes = 2
        when 18..20
            changes = 3
        end
        changes   
    end

    def display_character
        return "Here is your character: \nName: #{@name} \nClass: #{@character_class} \nEndurance: #{@traits[:endurance]} \nIntelligence: #{@traits[:intelligence]} \nDexterity: #{@traits[:dexterity]} \nNumber of Passes: #{@passes} \nHealth Points: #{@hp}"
    end

    def pass_word
    end

    def change_word
    end

end