class GamesController < ApplicationController
  def index
    @games = Game.where(day: params[:date])
  end
  
  def show
  end
  
end
