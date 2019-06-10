class PlayerSeasonsController < ApplicationController
  def shooting
    @player_seasons = PlayerSeason.where(year: params[:season]).order(prophet_rating: :desc).first(50)
  end
end
