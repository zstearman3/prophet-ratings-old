class GamesController < ApplicationController
  before_action :set_game, only: [:show]
  def index
    @games = Game.where(day: params[:date]).order(date_time: :asc)
    @predictions = Prediction.where(day: params[:date])
  end
  
  def show
    @season = Season.find_by(season: @game.year)
    @away_team_game = @game.team_games.find_by(home_or_away: 'AWAY')
    @home_team_game = @game.team_games.find_by(home_or_away: 'HOME')
    @away_team = @away_team_game.team
    @home_team = @home_team_game.team
    @away_player_games = @game.player_games.where(team: @away_team).order(minutes: :desc)
    @home_player_games = @game.player_games.where(team: @home_team).order(minutes: :desc)
    @away_team_season = TeamSeason.find_by(team: @away_team, season: @season)
    @home_team_season = TeamSeason.find_by(team: @home_team, season: @season)
  end
  
  private 
    def set_game
      @game = Game.find(params[:id])
    end
end
