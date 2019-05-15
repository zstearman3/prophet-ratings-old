class Team < ApplicationRecord
  has_many :players
  has_many :player_seasons
  has_many :team_seasons, dependent: :destroy
  has_many :home_games, class_name: 'Game', foreign_key: 'home_team_id'
  has_many :away_games, class_name: 'Game', foreign_key: 'away_team_id'
  belongs_to :conference
  belongs_to :stadium, optional: true
  validates :school, presence: true, uniqueness: { case_sensitive: false }
end
