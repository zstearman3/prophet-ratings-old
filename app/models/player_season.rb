class PlayerSeason < ApplicationRecord
  has_many :player_games
  belongs_to :player
  belongs_to :team, optional: true
  belongs_to :season, optional: true
  belongs_to :team_season, optional: true
  validates :year, presence: true
  validates :name, presence: true
  validates :team_name, presence: true
end
