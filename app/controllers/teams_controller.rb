class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
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
