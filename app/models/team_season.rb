class TeamSeason < ApplicationRecord
  belongs_to :team
  belongs_to :season, optional: true
  belongs_to :conference, optional: true
  has_many :player_seasons
  
  def school
    team.school
  end
  
  def conference
    team.conference
  end
  
  def conference_name
    team.conference.name
  end
  
  def conference_abbr
    team.conference.abbreviation
  end
end
