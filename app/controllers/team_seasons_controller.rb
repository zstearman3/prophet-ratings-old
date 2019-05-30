class TeamSeasonsController < ApplicationController
  helper_method :sort_column, :sort_direction
  
  def shooting
    @team_seasons = TeamSeason.where(year: params[:season]).order("#{sort_column} #{sort_direction}")
  end
  
  def defense
    @team_seasons = TeamSeason.where(year: params[:season]).order("#{sort_column} #{sort_direction}")
  end
  
  def rebounding
    @team_seasons = TeamSeason.where(year: params[:season]).order("#{sort_column} #{sort_direction}")
  end
  
  def miscellaneous
    @team_seasons = TeamSeason.where(year: params[:season]).order("#{sort_column} #{sort_direction}")
  end
  
  def rankings
    if params[:season]
      @team_seasons = TeamSeason.where(year: params[:season]).order("#{sort_column} #{sort_direction}")
    else
      @team_seasons = TeamSeason.where(year: current_season.season).order("#{sort_column} #{sort_direction}")
    end
  end
  
  private 
    def sortable_columns
      ['name', 'wins', 'adjem_rank', 'adj_offensive_efficiency', 'adj_defensive_efficiency', 'adj_tempo', 
       'field_goals_percentage', 'effective_field_goals_percentage', 'three_pointers_percentage', 'assists_percentage',
       'turnovers_percentage', 'free_throws_rate', 'assists_percentage_allowed', 'turnovers_percentage_allowed', 'free_throws_rate_allowed', 
       'home_advantage', 'two_pointers_percentage', 'true_shooting_percentage', 'offensive_efficiency', 'free_throws_percentage',
       'offensive_rebounds_percentage', 'defensive_rebounds_percentage', 'total_rebounds_percentage', 'offensive_rebounds', 'defensive_rebounds',
       'rebounds', 'defensive_efficiency', 'steals_percentage', 'blocks_percentage', 'true_shooting_percentage_allowed', 'defensive_aggression',
       'defensive_fingerprint']
    end
    
    def sort_column
      sortable_columns.include?(params[:column]) ? params[:column] : 'adjem_rank'
    end
  
    def sort_direction(init_direction = nil)
      init_direction ||= "asc"
      %w[asc desc].include?(params[:direction]) ? params[:direction] : init_direction
    end
end
