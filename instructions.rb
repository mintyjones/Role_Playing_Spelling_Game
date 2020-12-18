class Instructions
    def initialize
        @my_str = %Q(
Welcome to the game, #{ARGV[0]}

Start off by creating a character (Barbarian, Wizard or Thief). You have the chance to re-roll if you're not happy.

Gameplay is simple, you will be presented with 3 waves of enemies, in the form of a collection of words of increasing difficulty. You will be presneted with a word on screen, and then it will be removed. You start typing the word at this point, and if you get it right within a specified time limit you'll have struck down a minion. If not, you will lose a life and get to reattempt that word.

The faster you get a correct answer, the higher your score will be.

Characters have special abilities they can use:

All characters have the "PASS" ability (although this depends on their intelligence trait)

If you have PASSES available, you can simply press enter instead of inputting a word. This will automatically defeat the current enemy.

If you are out of passes and you perform a pass, you will lose a life instead, so be careful.

Character classes have specific powers - these are activated by inputting a number "1" and pressing enter:

BARBARIAN - "BIG STRIKE"
You can clear half of the remaining wave and sacrfice 2 health points.

WIZARD - "SLOW TIME"
Double the time that the words appear on the screen, but sacrifice 5 intelligence points

THIEF - "BE SNEAKY"
This is still to be implemented
            
        )
    end

    def to_s
        @my_str
    end
end