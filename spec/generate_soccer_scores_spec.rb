require 'spec_helper'
require_relative '../generate_soccer_scores'

describe "SoccerScoreGenerator" do
    let(:described_class) { SoccerScoreGenerator.new}

    ###
    # Block: Input/output
    ###
    describe '#score_row' do
        it 'should handle singular' do
            data = ["Team name", 1]
            expected_value = "Team name, 1 pt"
            expect(described_class.score_row(data)).to eq expected_value
        end
        it 'should handle plural' do
            data = ["Team name", 2]
            expected_value = "Team name, 2 pts"
            expect(described_class.score_row(data)).to eq expected_value
        end
    end
 
    describe '#output_rows' do
        it 'handles no scores' do
            days_of_points = {}
            expected_value = []
            expect(described_class.output_rows(days_of_points)).to match_array expected_value
        end

        it 'handles exactly one score' do
            days_of_points = {1 => {"only team" =>  5}}
            expected_value = [
                "Matchday 1", 
                "only team, 5 pts", 
                ""]
            expect(described_class.output_rows(days_of_points)).to match_array expected_value
        end

        it 'sorts scores by number, using names in case of a tie' do
            days_of_points = {1 => {"a team" =>  3, "b team" => 3, "c team" => 3, "d team" => 5}}
            expected_value = [
                "Matchday 1", 
                "d team, 5 pts", 
                "a team, 3 pts", 
                "b team, 3 pts", 
                 ""]
            expect(described_class.output_rows(days_of_points)).to match_array expected_value
        end

        it 'handles multiple days' do
            days_of_points = {1 => {"a team" =>  3}, 2=>  {"b team" => 3}}
            expected_value = [
                "Matchday 1", 
                "a team, 3 pts", 
                "", 
                "Matchday 2",
                "b team, 3 pts", 
                 ""]
            expect(described_class.output_rows(days_of_points)).to match_array expected_value
        end
    end

end 