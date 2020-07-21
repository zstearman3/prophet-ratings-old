class Season < ApplicationRecord
  CURRENT_YEAR = 2020
  has_many :team_seasons
  has_many :player_seasons
  has_many :team_games
  has_many :player_games
  has_many :predictions
  validates :season, presence: true, uniqueness: true
  validates :regular_season_start_date, presence: true
  validates :post_season_end_date, presence: true
  
  def self.current_season
    Season.find_by(season: CURRENT_YEAR)
  end
  
  def rankings_to_hash
    rankings_hash = {}
    team_seasons.each do |team_season| 
      rankings_hash[team_season.id] = team_season.adj_efficiency_margin
    end
    rankings_hash
  end
end
