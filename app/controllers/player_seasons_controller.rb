class PlayerSeasonsController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user, only: [:edit, :update, :destroy] 
  helper_method :sort_column, :sort_direction
  
  def advanced
    @player_seasons = PlayerSeason.where(year: params[:season]).where("minutes > ?", 200)
    if params[:conference_id].to_i > 0
      if params[:conference_id].to_i == 50
        conferences_list = [2, 4, 5, 7, 8, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 25, 27, 28, 29, 30, 31, 32, 33]
        @player_seasons = @player_seasons.where(conference_id: conferences_list)
      elsif params[:conference_id].to_i == 40
        conferences_list = [1, 3, 6, 9, 10, 15, 24, 26]
        @player_seasons = @player_seasons.where(conference_id: conferences_list)
      else
        @player_seasons = @player_seasons.where(conference_id: params[:conference_id])
      end
    end
    @player_seasons = @player_seasons.order("#{sort_column} #{sort_direction}").paginate(page: params[:page], per_page: 100)    
    @conferences = Conference.order(name: :asc).all.as_json
    @conferences << {"id" => 40, "name" => "Powers"}
    @conferences << {"id" => 50, "name" => "Mid-Majors"}
    @conferences.to_json  
  end
  
  def shooting
    @player_seasons = PlayerSeason.where(year: params[:season]).where("points > ?", 200).order("#{sort_column} #{sort_direction}").paginate(page: params[:page], per_page: 100)
    if params[:conference_id].to_i > 0
      if params[:conference_id].to_i == 50
        conferences_list = [2, 4, 5, 7, 8, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 25, 27, 28, 29, 30, 31, 32, 33]
        @player_seasons = @player_seasons.where(conference_id: conferences_list)
      elsif params[:conference_id].to_i == 40
        conferences_list = [1, 3, 6, 9, 10, 15, 24, 26]
        @player_seasons = @player_seasons.where(conference_id: conferences_list)
      else
        @player_seasons = @player_seasons.where(conference_id: params[:conference_id])
      end
    end
    @player_seasons = @player_seasons.order("#{sort_column} #{sort_direction}").paginate(page: params[:page], per_page: 100)    
    @conferences = Conference.order(name: :asc).all.as_json
    @conferences << {"id" => 40, "name" => "Powers"}
    @conferences << {"id" => 50, "name" => "Mid-Majors"}
    @conferences.to_json
  end
  
  def miscellaneous
  
  end
  
  def preseason
    @player_seasons = PlayerSeason.where(year: (current_season.season + 1)).order(prophet_rating: :desc)
    if params[:conference_id].to_i > 0
      if params[:conference_id].to_i == 50
        conferences_list = [2, 4, 5, 7, 8, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 25, 27, 28, 29, 30, 31, 32, 33]
        @player_seasons = @player_seasons.where(conference_id: conferences_list)
      elsif params[:conference_id].to_i == 40
        conferences_list = [1, 3, 6, 9, 10, 15, 24, 26]
        @player_seasons = @player_seasons.where(conference_id: conferences_list)
      else
        @player_seasons = @player_seasons.where(conference_id: params[:conference_id])
      end
    end
    @player_seasons = @player_seasons.order("#{sort_column} #{sort_direction}").paginate(page: params[:page], per_page: 100)    
    @conferences = Conference.order(name: :asc).all.as_json
    @conferences << {"id" => 40, "name" => "Powers"}
    @conferences << {"id" => 50, "name" => "Mid-Majors"}
    @conferences.to_json
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
       'blocks_percentage', 'turnovers_percentage', 'usage_rate', 'player_efficiency_rating', 'prophet_rating', 'player_of_the_games', 'name', 'team_name']
    end
    
    def sort_column
      sortable_columns.include?(params[:column]) ? params[:column] : 'prophet_rating'
    end
  
    def sort_direction(init_direction = nil)
      init_direction ||= "desc"
      %w[asc desc].include?(params[:direction]) ? params[:direction] : init_direction
    end
end
