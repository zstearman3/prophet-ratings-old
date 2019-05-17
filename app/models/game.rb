class Game < ApplicationRecord
  belongs_to :home_team, class_name: 'Team', foreign_key: 'home_team_id', optional: true
  belongs_to :away_team, class_name: 'Team', foreign_key: 'away_team_id', optional: true
  belongs_to :season
  belongs_to :stadium, optional: true
  has_many :team_games
  validates :status, presence: true
  validates :day, presence: true
end
