class TeamSeasonsController < ApplicationController
  def shooting
    @team_seasons = TeamSeason.where(year: params[:season])
  end
end
