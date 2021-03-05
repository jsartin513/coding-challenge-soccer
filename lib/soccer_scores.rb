require_relative './game_processor'

class SoccerScores
  # @param points_for_today, current total of points for the day
  # @param game, current game being processed
  # @return boolean, whether the game represents the start of a new day
  def is_new_day(points_for_today, game)
    val = points_for_today.keys.include?(game.keys[0]) && points_for_today.keys.include?(game.keys[1])
  end

  # @returns Hash, all games by day, in the format of
  # { 1 : {name, score}}
  def match_points_by_day(parsed_games)
    # Initializers to keep track of scores both by day and culmulatively
    points_for_today = {}
    culmulative_points = {}
    culmulative_points.default = 0
    # We could use a list here, instead use a Hash so we can more easily display the match day
    day_results = {}
    day = 1

    # We can assume that the days are in order
    parsed_games.each do |game_results|
      # We check to see if the new game is part of a new day before processing,
      # so that we can close out the previous day's results if so
      if is_new_day(points_for_today, game_results)
        day_results[day] = {}.merge!(culmulative_points)
        day += 1
        points_for_today = {}
      end

      game_results.each do |name, score|
        culmulative_points[name] += score
      end
      points_for_today.merge!(game_results)
    end
    # Process the final day
    # TODO: Consider how we would handle just one day's worth of data
    day_results[day] = {}.merge!(culmulative_points)
    day_results
  end
end
