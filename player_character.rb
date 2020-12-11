class PlayerCharacter
    attr_reader :traits
    def initialize(name, hp, character_class)
        @name = name
        @hp = hp
        @character_class = character_class
        @traits = Hash.new{}
        @traits[:endurance] = rand(5..20)
        @traits[:intelligence] = rand(5..20)
        @traits[:dexterity] = rand(5..20)
    end

    def pass_word
    end

    def change_word
    end

end