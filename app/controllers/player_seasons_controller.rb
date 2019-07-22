class PlayerSeasonsController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user, only: [:edit, :update, :destroy] 
  helper_method :sort_column, :sort_direction
  
  def advanced
    @player_seasons = PlayerSeason.where(year: params[:season]).where("games_percentage > ?", 50).where("minutes_percentage > ?", 35).order("#{sort_column} #{sort_direction}").paginate(page: params[:page], per_page: 100)
  end
  
  def shooting
    @player_seasons = PlayerSeason.where(year: params[:season]).where("games_percentage > ?", 50).where("points_per_game > ?", 8).order("#{sort_column} #{sort_direction}").paginate(page: params[:page], per_page: 100)
  end
  
  def miscellaneous
  
  end
  
  def preseason
    @player_seasons = PlayerSeason.where(year: (current_season.season + 1)).order(prophet_rating: :desc).order("#{sort_column} #{sort_direction}").paginate(page: params[:page], per_page: 100)
  end
  
  def edit
    @player_season = PlayerSeason.find(params[:id])
  end
  
  def update
    @player_season = PlayerSeason.find(params[:id])
    team = @player_season.team
    if @player_season.update(player_season_params)
      flash[:success] = "Player Season Updated"
      redirect_to preseason_path(team: team)
    else
      render 'edit'
    end
  end
  
  def destroy
    @player_season = PlayerSeason.find(params[:id])
    team = @player_season.team
    @player_season.destroy
    flash[:success] = "Player Season was destroyed"
    redirect_to preseason_path(team: team)
  end
  
  private 
    def player_season_params
      params.require(:player_season).permit(:prophet_rating, :team_id)
    end

    def sortable_columns
      ['prophet_rating', 'two_pointers_percentage', 'three_pointers_percentage', 'field_goals_percentage', 'effective_field_goals_percentage', 'true_shooting_percentage',
       'points', 'points_per_game', 'assists_percentage', 'offensive_rebounds_percentage', 'defensive_rebounds_percentage', 'total_rebounds_percentage', 'steals_percentage',
       'blocks_percentage', 'turnovers_percentage', 'usage_rate', 'player_efficiency_rating', 'prophet_rating', 'player_of_the_games']
    end
    
    def sort_column
      sortable_columns.include?(params[:column]) ? params[:column] : 'prophet_rating'
    end
  
    def sort_direction(init_direction = nil)
      init_direction ||= "desc"
      %w[asc desc].include?(params[:direction]) ? params[:direction] : init_direction
    end
end
