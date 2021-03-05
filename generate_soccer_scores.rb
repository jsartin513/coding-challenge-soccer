#!/usr/bin/ruby

class SoccerScoreGenerator
    DEFAULT_INPUT_FILENAME = "sample-input.txt"
    DEFAULT_OUTPUT_FILENAME = "default-output.txt"
    NUM_SCORES_PER_DAY = 3

    def initialize(input_filename: DEFAULT_INPUT_FILENAME, output_filename: DEFAULT_OUTPUT_FILENAME)
        @input_filename = input_filename
        @output_filename = output_filename
    end


    ###
    # Block: Reading from and writing into the file
    ###

    # All games data as read from the file
    def all_games
        file = File.open(@input_filename)
        games = file.readlines.map(&:chomp)
        file.close
        games
    end

    # Writes the file of culmulative results
    def write_file
        File.open(@output_filename, "w+") do |f|
            output_rows(match_points_by_day).each do |row|
                f.puts(row)
            end
        end
    end

    # Given a score in the form of [name, score], produce the output row
    def score_row(data)
        name = data[0]
        score = data[1]
        pt_text = score == 1 ? "pt" : "pts"
        "#{name}, #{score} #{pt_text}"
    end

    # All rows that we need to output, for all days.
    def output_rows(days_of_points)
        rows = []
        days_of_points.each do |day, scores|
            # This sorts the teams by high-score followed by name, so that
            # we can easily iterate through the top X number of scores
            top_scores = scores.sort_by { |team, score| [-score, team] }
            rows << "Matchday #{day.to_s}"
            top_scores[0..NUM_SCORES_PER_DAY - 1].each do |top_score|
                rows << score_row(top_score)
            end
            # Buffer between days
            # Ideally, clean this up and take out on the last day
            rows << ""
        end
        rows
    end

    ###
    # Block: Processing individual games
    ###

    # @param parsed_game (Array<Hash>) a game pased in the format of
    # [{name:score}]
    # @returns Hash in the form of {name:points_earned}
    def process_game(parsed_game)
        result = {}

        if parsed_game[0][:score] == parsed_game[1][:score]
            result = {
                parsed_game[0][:name] => 1,
                parsed_game[1][:name] => 1
            }
        else
            parsed_game.sort_by! { |team_score| team_score[:score]}
            result = {
                parsed_game[0][:name] => 0,
                parsed_game[1][:name] => 3
            }
        end

        return result
    end

    # @param raw_game String, a game passed in the format of 
    # San Jose Earthquakes 3, Santa Cruz Slugs 3
    # @returns Hash of a parsed game, in the form of {name:points_earned}
    def parse_game(raw_game)
        game_score = {}

        scores_objects = []
        raw_game.split(',').each do |team_score|
            name = team_score[0..team_score.length - 3].strip
            # TODO: Handle double digit scores
            score = team_score[team_score.length - 1]
            game_score[name] = score
            scores_objects << {name: name, score: score}
        end
        scores_objects
    end



    ###
    # Block: Processing sets of games
    ###

    # @param points_for_today, current total of points for the day
    # @param game, current game being processed
    # @return boolean, whether the game represents the start of a new day
    def is_new_day(points_for_today, game)
        val = points_for_today.keys.include?(game.keys[0]) && points_for_today.keys.include?(game.keys[1])
    end

    # @returns Hash, all games by day, in the format of
    # { 1 : {name, score}}
    def match_points_by_day
        # Initializers to keep track of scores both by day and culmulatively
        points_for_today = {}
        culmulative_points = {}
        culmulative_points.default = 0
        # We could use a list here, instead use a Hash so we can more easily display the match day
        day_results = {}
        day = 1

        # We can assume that the days are in order
        all_games.each do |game|
            game_results = process_game(parse_game(game))
            
            # We check to see if the new game is part of a new day before processing,
            # so that we can close out the previous day's results if so
            if is_new_day(points_for_today, game_results)
                day_results[day] = Hash.new.merge!(culmulative_points)
                day += 1
                points_for_today = {}
            end

            game_results.each do |name, score|
                culmulative_points[name] += score
            end
            points_for_today.merge!(game_results)
            
        end
        # Process the final day
        day_results[day] = Hash.new.merge!(culmulative_points)
        day_results
    end
end

if __FILE__ == $0
    SoccerScoreGenerator.new.write_file
  end
