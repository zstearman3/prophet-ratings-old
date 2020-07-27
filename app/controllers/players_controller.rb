class PlayersController < ApplicationController
  before_action :logged_in_user
  
  def show
    @player = Player.find(params[:id])
    @team = @player.team
    @player_seasons = PlayerSeason.where(player: @player).where("minutes > ?", 0).order(year: :desc)
    @player_games = @player.player_games.order(day: :desc).first(5)
  end
  
  private
  
    def player_params
      params.require(:player).permit(:team_id, :first_name, :last_name, :active)
    end
    
end
