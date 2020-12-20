class HighScores 

    # Limit this to 20 lines
    def initialize
        score_array = []
        begin
            # This is a behaviour that mimicks storing data to a DB - for now its just a file that we are dealing with
            YAML.load_stream(File.read 'highscores.yml') { |doc| score_array << doc }
        rescue Errno::ENOENT
            puts "You are the first to play the game..."
            puts "...there are no scores for a leaderboard yet - good luck on your first try!"
        end
        score_array.sort_by!{|x|  x[:playerscore] }.reverse!
        top_ten = score_array[0, 10]
        @table = TTY::Table.new
        @table << ["Name","High Score"]
        top_ten.each do |score|
            @table << score.values
        end
    end

    def to_s
        @table.render(:unicode)
    end
end