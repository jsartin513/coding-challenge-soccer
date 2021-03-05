#!/usr/bin/ruby

class SoccerScoreGenerator
    DEFAULT_INPUT_FILENAME = "sample-input.txt"
    DEFAULT_OUTPUT_FILENAME = "default-output.txt"

    def initialize(input_filename: DEFAULT_INPUT_FILENAME, output_filename: DEFAULT_OUTPUT_FILENAME)
        @input_filename = input_filename
        @output_filename = output_filename
    end

    def scores 
    end


    #yeah fix this for sure
    def all_games
        file = File.open(@input_filename)
        games = file.readlines.map(&:chomp)
        file.close
        games
    end

    def games_sorted_by_day
        all_days = []

        scores_for_today = {}

        culmulative_scores = {}
        day = 1
        day_results = {}

        # assume in order for now, e.g.
        # each day happens before a new day starts
        all_games.each do |game|
            teams_scores = game.split(',') 

            team_1 = teams_scores[0]
            # TODO: remove last two chars
            team_1_name = team_1[0..team_1.length - 2]
            team_1_score = team_1.chars[team_1.length - 1]

            team_2 = teams_scores[1]
            # TODO: remove last two chars
            team_2_name = team_2[1..team_2.length - 2]
            team_2_score = team_2.chars[team_2.length - 1]

            if scores_for_today[team_1_name]
                all_days << scores_for_today
                day_results[day] = culmulative_scores
                day += 1
                scores_for_today = {}
            end

            # TODO: Better error handling
            unless culmulative_scores[team_1_name]
                culmulative_scores[team_1_name] = 0
            end

            # TODO: Better error handling
            unless culmulative_scores[team_2_name]
                culmulative_scores[team_2_name] = 0
            end
            

            # TODO: Make this nicer looking
            if team_1_score == team_2_score
                scores_for_today[team_1_name] = 1
                scores_for_today[team_2_name] = 1
                culmulative_scores[team_1_name] += 1
                culmulative_scores[team_1_name] += 1
                culmulative_scores[team_2_name] += 1
            elsif team_1_score > team_2_score
                scores_for_today[team_1_name] = 3
                culmulative_scores[team_1_name] += 3
                scores_for_today[team_2_name] = 0
            else
                scores_for_today[team_1_name] = 0
                scores_for_today[team_2_name] = 3
                culmulative_scores[team_2_name] += 3
            end      
        end
        # Get the last one, too!
        all_days << scores_for_today
        all_days #old return

        day_results[day] = culmulative_scores
        day_results
    end


    def write_File
    end
end


if __FILE__ == $0
    # TODO: allow reading from file, stdin, etc
    test_output = SoccerScoreGenerator.new.games_sorted_by_day
    print(test_output)
  end