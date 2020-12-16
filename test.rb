require_relative("./GetKey.rb")
require("tty-spinner")

# user_input = Thread.new do
#     print "Enter something: "
#     Thread.current[:value] = gets.chomp
#   end
  
#   timer = Thread.new { sleep 3; user_input.kill; puts }
  
#   user_input.join
#   if user_input[:value]
#     puts "User entered #{user_input[:value]}"
#   else
#     puts "Timer expired"
#   end

# require "pastel"

# require "tty-progressbar"

# pastel = Pastel.new
# green = pastel.on_green(" ")
# red = pastel.on_red(" ")



# t = Thread.new { 
#     bar = TTY::ProgressBar.new("|:bar|", total: 30, complete: green, incomplete: red)

#     30.times do
#     sleep(0.1)
#     bar.advance
#     end
    
#     system "clear"
#  }
# t.join
# t2 = Thread.new {
#     user_input = gets.chomp
#     puts user_input
# }
# t2.join
# user_input = gets.chomp
# puts user_input

# require 'timeout'
# x = 10
# begin
#   status = Timeout::timeout(x) {
#     printf "Input: "
#     gets
#   }
#   puts "Got: #{status}"
# rescue Timeout::Error
#   puts "\nInput timed out after #{x} seconds"
# end

# def quit?
#     begin
#       # See if a 'Q' has been typed yet
#       while c = STDIN.read_nonblock(1)
#         puts "I found a #{c}"
#         return true if c == 'Q'
#       end
#       # No 'Q' found
#       false
#     rescue Errno::EINTR
#       puts "Well, your device seems a little slow..."
#       false
#     rescue Errno::EAGAIN
#       # nothing was ready to be read
#       puts "Nothing to be read..."
#       false
#     rescue EOFError
#       # quit on the end of the input stream
#       # (user hit CTRL-D)
#       puts "Who hit CTRL-D, really?"
#       true
#     end
#   end
  
#   loop do
#     puts "I'm a loop!"
#     puts "Checking to see if I should quit..."
#     break if quit?
#     puts "Nope, let's take a nap"
#     sleep 5
#     puts "Onto the next iteration!"
#   end
  
#   puts "Oh, I quit."

# loop do
#     k = GetKey.getkey
#     # puts "Key pressed: #{k.inspect}"
#         if k.inspect == "49"
#             puts "Number 1 button pressed"
#         end
#     sleep 1
# end


spinner = TTY::Spinner.new("[:spinner] Task name")

spinner.auto_spin

sleep(2)

spinner.pause

sleep(2)

spinner.resume

sleep(2)

spinner.stop

puts