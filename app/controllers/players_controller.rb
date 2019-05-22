class PlayersController < ApplicationController
  def show
    @player = Player.find(params[:id])
    @player_seasons = PlayerSeason.where(player: @player).order(year: :desc)
    @player_games = @player.player_games.order(day: :desc).first(5)
  end
end
