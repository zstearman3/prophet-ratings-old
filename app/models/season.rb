class Season < ApplicationRecord
  has_many :team_seasons
  has_many :player_seasons
  has_many :team_games
  has_many :player_games
  validates :season, presence: true, uniqueness: true
end
