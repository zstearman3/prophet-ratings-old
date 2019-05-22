module SeasonsHelper
  def current_year
    return 2019
  end
  
  def current_season
    Season.find_by(season: current_year)
  end
end
