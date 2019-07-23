class TeamSeason < ApplicationRecord
  belongs_to :team
  belongs_to :season, optional: true
  belongs_to :conference, optional: true
  has_many :player_seasons
end
