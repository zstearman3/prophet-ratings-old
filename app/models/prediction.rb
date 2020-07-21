class Prediction < ApplicationRecord
  before_save :simulate_game
  belongs_to :game
  belongs_to :season
  validates :home_team_prediction, presence: true
  validates :away_team_prediction, presence: true
  
  def simulate_game
    game.display
  end
end
