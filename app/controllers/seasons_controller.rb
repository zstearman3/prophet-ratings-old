class SeasonsController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user
  
  def new
    @season = Season.new
  end
  
  def create
    @season = Season.new(season_params)
    if @season.save
      flash[:success] = "Season was successfully added."
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def index
    @seasons = Season.all.order(season: :desc)
  end
  
  private
    def season_params
      params.require(:season).permit(:season, :start_year, :end_year, :description, :regular_season_end_date, :regular_season_start_date)
    end
end
