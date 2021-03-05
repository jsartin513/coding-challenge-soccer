class GameProcessor
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
      scores_objects << { name: name, score: score }
    end
    scores_objects
  end

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
      parsed_game.sort_by! { |team_score| team_score[:score] }
      result = {
        parsed_game[0][:name] => 0,
        parsed_game[1][:name] => 3
      }
    end

    result
  end
end
