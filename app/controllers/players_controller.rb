class PlayersController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user, only: [:edit, :create]
  def show
    @player = Player.find(params[:id])
    @player_seasons = PlayerSeason.where(player: @player).where("minutes > ?", 0).order(year: :desc)
    @player_games = @player.player_games.order(day: :desc).first(5)
  end
  
  def new
    @player = Player.new(team_id: params[:team], active: false)
  end
  
  def create
    @player = Player.new(player_params)
    season = Season.find_by(season: 2020)
    if @player.save
      @player_season = PlayerSeason.new(year: 2020, player: @player, season: season, team: @player.team)
      @player_season.team_name = @player.team.school
      @player_season.name = @player.first_name + " " + @player.last_name
      if @player_season.save
        redirect_to edit_player_season_path(@player_season)
        return
      else
        redirect_to admin_path
      end
    else
      render 'new'
    end
  end
  
  private
  
  def player_params
    params.require(:player).permit(:team_id, :first_name, :last_name, :active)
  end
end
