class PredictionsController < ApplicationController
  def index
    @games = Game.where(day: params[:date]).order(date_time: :asc)
    @predictions = Prediction.where(day: params[:date])
  end
  
  def show
  
  end
end
