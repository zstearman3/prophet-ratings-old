class PredictionsController < ApplicationController
  before_action :logged_in_user
  helper_method :sort_column, :sort_direction
  def index
    @games = Game.where(day: params[:date]).order("#{sort_column} #{sort_direction}")
    @predictions = Prediction.where(day: params[:date])
  end
  
  def show
    @prediction = Prediction.find(params[:id])
    @game = @prediction.game
  end
  
  def statistics
    if params[:season]
      @season = Season.find_by(season: params[:season])
      @predictions = Prediction.where(season: @season)
    else
      @season = current_season
      @predictions = Prediction.where(season: @season)
    end
    @point_spread_wins = @predictions.where(win_point_spread: true).count
    @point_spread_losses = @predictions.where(win_point_spread: false).count
    @over_under_wins = @predictions.where(win_over_under: true).count
    @over_under_losses = @predictions.where(win_over_under: false).count
    @moneyline_wins = @predictions.where(win_moneyline: true).count
    @moneyline_losses = @predictions.where(win_moneyline: false).count
    @straight_up_wins = @predictions.where(win_straight_up: true).count
    @straight_up_losses = @predictions.where(win_straight_up: false).count
  end
  
  private
    def sortable_columns
      ['date_time', 'thrill_score']
    end
    
    def sort_column
      sortable_columns.include?(params[:column]) ? params[:column] : 'date_time'
    end
  
    def sort_direction(init_direction = nil)
      init_direction ||= "asc"
      %w[asc desc].include?(params[:direction]) ? params[:direction] : init_direction
    end
end
