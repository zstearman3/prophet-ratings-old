class TeamSeasonsController < ApplicationController
  def shooting
    @team_seasons = TeamSeason.where(year: params[:season]).order(adj_efficiency_margin: :desc)
  end
end
