class Game < ApplicationRecord
  belongs_to :home_team, class_name: 'Team', foreign_key: 'home_team_id', optional: true
  belongs_to :away_team, class_name: 'Team', foreign_key: 'away_team_id', optional: true
  belongs_to :season
  belongs_to :stadium, optional: true
  has_many :team_games
  has_many :player_games
  has_one  :prediction
  has_one  :player_of_the_game, :class_name => 'Player', :foreign_key => 'id'
  validates :status, presence: true
  validates :day, presence: true
end
