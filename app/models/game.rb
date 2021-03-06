class Game < ApplicationRecord
  belongs_to :home_team, class_name: 'Team', foreign_key: 'home_team_id', optional: true
  belongs_to :away_team, class_name: 'Team', foreign_key: 'away_team_id', optional: true
  belongs_to :season
  belongs_to :stadium, optional: true
  has_many :team_games
  has_many :player_games
  has_one  :prediction
  belongs_to :player_of_the_game, :class_name => 'Player', :foreign_key => 'player_of_the_game_id', optional: true
  validates :status, presence: true
  validates :day, presence: true
  
  def display
    "#{away_team.school} @ #{home_team.school}"
  end
  
end
