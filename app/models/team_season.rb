class TeamSeason < ApplicationRecord
  belongs_to :team
  belongs_to :season, optional: true
  has_many :player_seasons
end
