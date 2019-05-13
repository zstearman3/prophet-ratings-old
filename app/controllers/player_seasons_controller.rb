class PlayerSeasonsController < ApplicationController
  def shooting
    @player_seasons = PlayerSeason.where(year: params[:season]).first(50)
  end
end
