class HighScores 

    # Limit this to 20 lines
    def initialize
        score_array = []
        YAML.load_stream(File.read 'highscores.yml') { |doc| score_array << doc }
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