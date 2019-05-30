class TeamSeasonsController < ApplicationController
  def shooting
    @team_seasons = TeamSeason.where(year: params[:season]).order(true_shooting_percentage: :desc)
  end
  
  def defense
    @team_seasons = TeamSeason.where(year: params[:season]).order(adj_defensive_efficiency: :asc)
  end
  
  def rebounding
    @team_seasons = TeamSeason.where(year: params[:season]).order(defensive_rebounds_percentage: :desc)
  end
  
  def miscellaneous
    @team_seasons = TeamSeason.where(year: params[:season]).order(adjem_rank: :asc)
  end
  
  def rankings
    if params[:season]
      @team_seasons = TeamSeason.where(year: params[:season]).order(adj_efficiency_margin: :desc)
    else
      @team_seasons = TeamSeason.where(year: current_season.season).order(adj_efficiency_margin: :desc)
    end
  end
end
