class TeamSeasonsController < ApplicationController
  def index
    @team_seasons = TeamSeason.where(year: params[:season])
  end
end
