class PlayerSeasonsController < ApplicationController
  before_action :logged_in_user
  helper_method :sort_column, :sort_direction
  
  def advanced
    @player_seasons = PlayerSeason.where(year: params[:season]).where("games_percentage > ?", 50).where("minutes_percentage > ?", 35).order("#{sort_column} #{sort_direction}").paginate(page: params[:page], per_page: 100)
  end
  
  def shooting
    @player_seasons = PlayerSeason.where(year: params[:season]).where("games_percentage > ?", 50).where("points_per_game > ?", 8).order("#{sort_column} #{sort_direction}").paginate(page: params[:page], per_page: 100)
  end
  
  def miscellaneous
  
  end
  
  private 
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
