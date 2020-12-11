require_relative("./player-character.rb")

Class WizardClass < PlayerCharacter
def initialize(name, hp, traits)
  super(name, hp, "wizard", traits)
  @traits = 
end

def pass_word
end
