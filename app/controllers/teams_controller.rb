class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy, :rank_history]
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy, :show, :index]
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy, :preseason]
  
  def index
    @teams = Team.all.order(school: :asc)
  end

  def show
    if params[:year]
      @season = Season.find_by(season: params[:year])
    else
      @season = current_season
    end
    @player_seasons = @team.player_seasons.where(season: @season).order(minutes: :desc)
    @team_season = TeamSeason.find_by(team: @team, season: @season)
    @team_games = TeamGame.where(team: @team, season: @season).order(day: :asc)
    @away_games = Game.where(away_team: @team, season: @season).where("day > ?", Date.today - 1.day)
    @home_games = Game.where(home_team: @team, season: @season).where("day > ?", Date.today - 1.day)
    @games = @away_games + @home_games
    @games = @games.sort_by{|e| e[:day]}
  end

  def new
    @team = Team.new
  end

  def edit
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      flash[:success] = "Team successfully added."
      redirect_to teams_path
    else
      render 'new'
    end
  end

  def update
    if @team.update(team_params)
      flash[:success] = "Team was successfully updated."
      redirect_to @team
    else
      render 'edit'
    end
  end

  def destroy
    @team.destroy
    flash[:success] = "Team was successfully deleted."
    redirect_to teams_url
  end
  
  def preseason
    year = current_season.season + 1
    @team = Team.find(params[:team])
    @player_seasons = PlayerSeason.where(year: year, team: @team)
    @departed_players = []
    @transfered_players = []
    old_players = PlayerSeason.where(year: current_season.season, team: @team)
    old_players.each do |player|
      if PlayerSeason.find_by(player: player.player, year: year).nil?
        @departed_players << player
      else 
        new_season = PlayerSeason.find_by(player: player.player, year: year)
        if new_season.team != player.team
          @transfered_players << new_season
        end
      end
    end
  end
  
  def rank_history
    if params[:year]
      @season = Season.find_by(season: params[:year])
    else
      @season = current_season
    end
    @team_games = TeamGame.where(team: @team, season: @season).order(day: :asc)
    @team_season = TeamSeason.find_by(team: @team, season: @season)
    @rank_history = @team_games.where(season: @season).pluck(:day, :rank)
    @rank_history << [Date.today, @team_season.adjem_rank]
  end
  
  private
    def set_team
      begin
        @team = Team.find(params[:id])
      rescue Exception => e
        redirect_to teams_path
        flash[:danger] = e
      end
    end
  
    def team_params
      params.require(:team).permit(:school, :name, :conference_id, :wins, :losses, :conference_wins, :conference_losses, :short_display_name, :stadium_id)
    end
end
