class StadiaController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user
  
  def new
    @stadium = Stadium.new
  end
  
  def create
    @stadium = Stadium.new(stadium_params)
    if @stadium.save
      flash[:success] = "Stadium was successfully added."
      redirect_to teams_path
    else
      render 'new'
    end
  end
  
  private
    def stadium_params
      params.require(:stadium).permit(:name, :city, :state, :country, :capacity)
    end
end
