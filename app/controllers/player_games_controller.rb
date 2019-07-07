class PlayerGamesController < ApplicationController
  before_action :logged_in_user
  def index
    if params[:player]
      @player = Player.find(params[:player])
      @season = Season.find_by(season: params[:year]) if params[:year]
      @season ||= current_season
      @previous_season = Season.find_by(season: @season.season - 1)
      @games = PlayerGame.where(player: @player, season: @season).order(day: :desc)
    else
      redirect_to rankings_path
    end
  end
end
