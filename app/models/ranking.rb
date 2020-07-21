class Ranking < ApplicationRecord
  before_save :get_full_rankings
  serialize :full_rankings
  
  def team_seasons
    TeamSeason.where(season: Season.last)
  end
  
  private
    def get_full_rankings
      rankings_hash = {}
      team_seasons.each do |season|
        rankings_hash[season.id] = season.adj_efficiency_margin
      end
      self.full_rankings = rankings_hash
      self.date = Date.today
    end
end
