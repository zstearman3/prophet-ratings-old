class Prediction < ApplicationRecord
  belongs_to :game
  belongs_to :season
  validates :home_team_prediction, presence: true
  validates :away_team_prediction, presence: true
end
