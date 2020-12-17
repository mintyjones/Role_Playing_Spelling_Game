class HighScores 

    # Limit this to 20 lines
    def initialize
        score_array = []
        YAML.load_stream(File.read 'highscores.yml') { |doc| score_array << doc }
        score_array.sort_by!{|x|  x[:playerscore] }.reverse!
        @table = TTY::Table.new
        @table << ["Name","High Score"]
        score_array.each do |score|
            @table << score.values
        end
    end

    def to_s
        @table.render(:ascii)
    end
end