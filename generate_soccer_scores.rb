#!/usr/bin/ruby
require_relative './lib/soccer_scores'
require_relative './lib/game_processor'

###
### Reads the input file provided, 
### Calls other classes to parse and format the data
### Then prints results
### Usage 
###
class SoccerScoreGenerator
  DEFAULT_INPUT_FILENAME = 'sample-input.txt'
  DEFAULT_OUTPUT_FILENAME = 'default-output.txt'
  NUM_SCORES_PER_DAY = 3

  def initialize(input_filename: DEFAULT_INPUT_FILENAME, output_filename: DEFAULT_OUTPUT_FILENAME)
    @input_filename = input_filename
    @output_filename = output_filename
  end

  # All games data as read from the file
  def all_games
    file = File.open(@input_filename)
    games = file.readlines.map(&:chomp)
    file.close
    games
  end

  # Writes the file of culmulative results
  def write_file(match_points_by_day)
    File.open(@output_filename, 'w+') do |f|
      output_rows(match_points_by_day).each do |row|
        f.puts(row)
      end
    end
  end

  # Given a score in the form of [name, score], produce the output row
  def score_row(data)
    name = data[0]
    score = data[1]
    pt_text = score == 1 ? 'pt' : 'pts'
    "#{name}, #{score} #{pt_text}"
  end

  # All rows that we need to output, for all days.
  def output_rows(days_of_points)
    rows = []
    days_of_points.each do |day, scores|
      # This sorts the teams by high-score followed by name, so that
      # we can easily iterate through the top X number of scores
      top_scores = scores.sort_by { |team, score| [-score, team] }
      rows << "Matchday #{day}"
      top_scores[0..NUM_SCORES_PER_DAY - 1].each do |top_score|
        rows << score_row(top_score)
      end
      # Buffer between days
      rows << ''
    end
    # Take out the buffer on the very last day
    rows[0..rows.length - 2]
  end
end

if __FILE__ == $0
  generator = SoccerScoreGenerator.new
  game_processor = GameProcessor.new
  processed_games = generator.all_games.map do |game|
    game_processor.process_game(game_processor.parse_game(game))
  end
  match_points_by_day = SoccerScores.new.match_points_by_day(processed_games)
  generator.write_file(match_points_by_day)
end
