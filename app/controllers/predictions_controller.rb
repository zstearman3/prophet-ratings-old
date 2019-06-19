class PredictionsController < ApplicationController
  def index
    @games = Game.where(day: params[:date]).order(date_time: :asc)
    @predictions = Prediction.where(day: params[:date])
  end
  
  def show
  
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
  end
end
