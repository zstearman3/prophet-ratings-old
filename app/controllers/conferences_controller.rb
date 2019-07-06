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
    player_season_ids = []
    year = params[:season]
    year ||= current_season.season
    @teams.each do |team|
      season = team.team_seasons.find_by(year: year)
      team_season_ids << season.id
      players = team.player_seasons.where(year: year)
      players.each do |player|
        player_season_ids << player.id
      end
    end
    @team_seasons = TeamSeason.find(team_season_ids).sort_by(&:conference_wins).reverse
    @player_seasons = PlayerSeason.find(player_season_ids)
    max_minutes = @player_seasons.sort_by(&:minutes).reverse.first.minutes
    min_minutes = max_minutes / 2.0
    qualified_players = @player_seasons.select {|qualified| qualified["minutes"] > min_minutes}
    @points_leader = qualified_players.max_by{|z| z[:points_per_game]}
    @assists_leader = qualified_players.max_by{|y| y[:assists]}
    @rebounds_leader = qualified_players.max_by{|x| x[:rebounds_per_game]}
    @steals_leader = qualified_players.max_by{|w| w[:steals]}
    @blocks_leader = qualified_players.max_by{|v| v[:blocked_shots]}
    @prate_leader = qualified_players.max_by{|u| u[:prophet_rating]}
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
