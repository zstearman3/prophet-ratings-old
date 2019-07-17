class PlayersController < ApplicationController
  before_action :logged_in_user
  def show
    @player = Player.find(params[:id])
    @player_seasons = PlayerSeason.where(player: @player).where("year < ?", 2020).order(year: :desc)
    @player_games = @player.player_games.order(day: :desc).first(5)
  end
end
