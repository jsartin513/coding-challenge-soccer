require 'spec_helper'
require_relative '../../lib/game_processor'

describe 'GameProcessor' do
  let(:described_class) { GameProcessor.new }

  describe '#parse_game' do
    it 'handles single digit scores' do
      raw_game = 'San Jose Earthquakes 3, Santa Cruz Slugs 3'
      expected_value = [
        { name: 'San Jose Earthquakes', score: '3' },
        { name: 'Santa Cruz Slugs', score: '3' }
      ]
      expect(described_class.parse_game(raw_game)).to match_array expected_value
    end
  end

  describe '#process_game' do
    it 'handles ties' do
      parsed_game = [
        { name: 'San Jose Earthquakes', score: '3' },
        { name: 'Santa Cruz Slugs', score: '3' }
      ]
      expected_value = { 'San Jose Earthquakes' => 1, 'Santa Cruz Slugs' => 1 }
      expect(described_class.process_game(parsed_game)).to eq expected_value
    end

    it 'handles the first team winning' do
      parsed_game = [
        { name: 'San Jose Earthquakes', score: '5' },
        { name: 'Santa Cruz Slugs', score: '3' }
      ]
      expected_value = { 'San Jose Earthquakes' => 3, 'Santa Cruz Slugs' => 0 }
      expect(described_class.process_game(parsed_game)).to eq expected_value
    end

    it 'handles the second team winning' do
      parsed_game = [
        { name: 'San Jose Earthquakes', score: '3' },
        { name: 'Santa Cruz Slugs', score: '5' }
      ]
      expected_value = { 'San Jose Earthquakes' => 0, 'Santa Cruz Slugs' => 3 }
      expect(described_class.process_game(parsed_game)).to eq expected_value
    end
  end
end
