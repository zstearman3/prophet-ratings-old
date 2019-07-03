class ConferencesController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user, only: [:edit, :update, :index, :destroy]
  
  def index
    @conferences = Conference.all
  end

  def show
    @conference = Conference.find(params[:id])
    @teams = @conference.teams
    team_season_ids = []
    @teams.each do |team|
      season = team.team_seasons.find_by(season: current_season)
      team_season_ids << season.id
    end
    @team_seasons = TeamSeason.find(team_season_ids).sort_by(&:conference_wins).reverse
    
  end


  def edit
    @conference = Conference.find(params[:id])
  end

  def update
    @conference = Conference.find(params[:id])
    if @conference.update(conference_params)
      flash[:success] = "Conference successfully updated."
      redirect_to conferences_path
    else
      render 'edit'
    end
  end

  def destroy
  end
  
  private
    def conference_params
      params.require(:conference).permit(:name, :abbreviation)
    end
    
end
