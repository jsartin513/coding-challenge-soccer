require 'spec_helper'
require_relative '../../lib/soccer_scores'

describe 'SoccerScores' do
  let(:described_class) { SoccerScores.new }

  describe '#is_new_day' do
    it 'is a new day' do
      points_for_today = {
        'team a' => 0,
        'team b' => 3,
        'team c' => 3,
        'team d' => 6
      }
      game = { 'team c' => 1, 'team d' => 4 }

      expect(described_class.is_new_day(points_for_today, game)).to eq true
    end

    it 'is not a new day' do
      points_for_today = {
        'team a' => 0,
        'team b' => 3
      }
      game = { 'team c' => 3, 'team d' => 6 }

      expect(described_class.is_new_day(points_for_today, game)).to eq false
    end
  end

  describe '#match_points_by_day' do
   # TODO: As mentioned in soccer_scores.rb, clean up this case
    it 'with no games' do
      parsed_games = []
      expected_value = { 1 => {} }
      expect(described_class.match_points_by_day(parsed_games)).to eq expected_value
    end

    it 'with one day of games ' do
      parsed_games = [{ 'team a' => 0, 'team b' => 3 }]
      expected_value = { 1 => {"team a"=>0, "team b"=>3} }
      expect(described_class.match_points_by_day(parsed_games)).to eq expected_value
    end

    it 'with multiple days of games ' do
      parsed_games = [{ 'team a' => 0, 'team b' => 3 }, { 'team a' => 1, 'team b' => 1 }]
      expected_value = { 1 => {"team a"=>0, "team b"=>3}, 2 => {"team a"=>1, "team b"=>4} }
      expect(described_class.match_points_by_day(parsed_games)).to eq expected_value
    end
  end
end
