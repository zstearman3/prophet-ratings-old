class PlayerSeasonsController < ApplicationController
  helper_method :sort_column, :sort_direction
  
  def shooting
    @player_seasons = PlayerSeason.where(year: params[:season]).order("#{sort_column} #{sort_direction}").paginate(page: params[:page], per_page: 100)
  end
  
  private 
    def sortable_columns
      ['prophet_rating']
    end
    
    def sort_column
      sortable_columns.include?(params[:column]) ? params[:column] : 'prophet_rating'
    end
  
    def sort_direction(init_direction = nil)
      init_direction ||= "desc"
      %w[asc desc].include?(params[:direction]) ? params[:direction] : init_direction
    end
end
