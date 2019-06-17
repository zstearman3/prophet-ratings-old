class PlayerGamesController < ApplicationController
  def index
    @player = Player.find(params[:player])
    @previous_season = Season.find_by(season: current_season.season - 1)
    @games = PlayerGame.where(player: @player, season: current_season).order(day: :desc)
    @oldgames = PlayerGame.where(player: @player, season: @previous_season).order(day: :desc)
  end
end
