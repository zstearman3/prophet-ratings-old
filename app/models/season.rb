class Season < ApplicationRecord
  has_many :team_seasons
  has_many :player_seasons
  has_many :team_games
  has_many :player_games
  has_many :predictions
  validates :season, presence: true, uniqueness: true
  validates :regular_season_start_date, presence: true
  validates :post_season_end_date, presence: true
end
