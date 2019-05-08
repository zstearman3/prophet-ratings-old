class Season < ApplicationRecord
  has_many :team_seasons
  has_many :player_seasons
  validates :season, presence: true, uniqueness: true
end
