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
      @team_seasons = team_seasons
      @conferences = Conference.conferences
      @year = year.to_i
      @conference_id = params[:conference_id]
    end
    
    def year
      params[:season] ? params[:season] : Season.current_year
    end
    
    def team_seasons
      team_seasons = TeamSeason.where(year: year)
      team_seasons = team_seasons.where(conference_id: conference_ids) if conference_ids
      team_seasons = team_seasons.order("#{sort_column} #{sort_direction}")
    end
    
    def conference_ids
      Conference.return_ids(params[:conference_id])
    end
    
    def sort_column
      params[:column] ? params[:column] : 'adjem_rank'
    end
  
    def sort_direction(init_direction = nil)
      init_direction ||= "asc"
      %w[asc desc].include?(params[:direction]) ? params[:direction] : init_direction
    end
      
end
