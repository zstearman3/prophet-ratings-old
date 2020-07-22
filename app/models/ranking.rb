class Ranking < ApplicationRecord
  before_save :get_full_rankings
  serialize :full_rankings
  
  def current_hash
    Season.current_season.rankings_to_hash
  end
  
  private
    def get_full_rankings
      self.full_rankings = current_hash
      self.date = Date.today
    end
end
