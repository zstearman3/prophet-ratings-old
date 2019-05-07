class TeamSeason < ApplicationRecord
  belongs_to :team
  belongs_to :season, optional: true
end
