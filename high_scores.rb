class HighScores 
    def initialize
        score_array = []
        YAML.load_stream(File.read 'highscores.yml') { |doc| score_array << doc }
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