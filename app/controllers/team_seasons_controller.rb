class TeamSeasonsController < ApplicationController
  before_action :logged_in_user, only: [:shooting, :defense, :rebounding, :miscellaneous]
  before_action :set_instance_variables
  helper_method :sort_column, :sort_direction
  
  def shooting
  end
  
  def defense
  end
  
  def rebounding
  end
  
  def miscellaneous
  end
  
  def rankings
  end
  
  private 
  
    def set_instance_variables
      @team_seasons = TeamSeason.where(year: year)
      @team_seasons = @team_seasons.where(conference_id: conference_ids) if conference_ids
      @team_seasons = @team_seasons.order("#{sort_column} #{sort_direction}")
      @conferences = Conference.order(name: :asc).all.as_json
      @conferences << {"id" => 40, "name" => "Powers"}
      @conferences << {"id" => 50, "name" => "Mid-Majors"}
      @conferences.to_json 
    end
    
    def sortable_columns
      ['name', 'wins', 'adjem_rank', 'adj_offensive_efficiency', 'adj_defensive_efficiency', 'adj_tempo', 
       'field_goals_percentage', 'effective_field_goals_percentage', 'three_pointers_percentage', 'assists_percentage',
       'turnovers_percentage', 'free_throws_rate', 'assists_percentage_allowed', 'turnovers_percentage_allowed', 'free_throws_rate_allowed', 
       'home_advantage', 'two_pointers_percentage', 'true_shooting_percentage', 'offensive_efficiency', 'free_throws_percentage',
       'offensive_rebounds_percentage', 'defensive_rebounds_percentage', 'total_rebounds_percentage', 'offensive_rebounds', 'defensive_rebounds',
       'rebounds', 'defensive_efficiency', 'steals_percentage', 'blocks_percentage', 'true_shooting_percentage_allowed', 'defensive_aggression',
       'defensive_fingerprint', 'adj_efficiency_margin', 'consistency', 'conference_wins', 'strength_of_schedule', 'ooc_strength_of_schedule',
       'two_pointers_percentage_allowed', 'three_pointers_percentage_allowed']
    end
    
    def sort_column
      sortable_columns.include?(params[:column]) ? params[:column] : 'adjem_rank'
    end
  
    def sort_direction(init_direction = nil)
      init_direction ||= "asc"
      %w[asc desc].include?(params[:direction]) ? params[:direction] : init_direction
    end
    
    def year
      params[:season] ? params[:season] : Season.current_year
    end
    
    def conference_ids
      return nil if (params[:conference_id].to_i == 0)
      if params[:conference_id].to_i == 50
        major_conferences
      elsif params[:conference_id].to_i == 40
        mid_major_conferences
      else
        params[:conference_id]
      end
    end
    
    def major_conferences
      [2, 4, 5, 7, 8, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 25, 27, 28, 29, 30, 31, 32, 33]
    end
    
    def mid_major_conferences
      [1, 3, 6, 9, 10, 15, 24, 26]
    end
end
