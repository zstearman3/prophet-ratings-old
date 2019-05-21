class GamesController < ApplicationController
  before_action :set_game, only: [:show]
  def index
    @games = Game.where(day: params[:date])
  end
  
  def show
    @away_team_game = @game.team_games.find_by(home_or_away: 'AWAY')
    @home_team_game = @game.team_games.find_by(home_or_away: 'HOME')
    @away_team = @away_team_game.team
    @home_team = @home_team_game.team
    @away_player_games = @game.player_games.where(team: @away_team)
    @home_player_games = @game.player_games.where(team: @home_team)
  end
  
  private 
    def set_game
      @game = Game.find(params[:id])
    end
end
