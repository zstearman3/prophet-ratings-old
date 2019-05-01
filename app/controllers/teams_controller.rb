class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy]
  
  def index
    @teams = Team.all
  end

  def show
  end

  def new
    @team = Team.new
  end

  def edit
  end

  def create
    @team = Team.new(team_params)
    if @team.save
      flash[:success] = "Team successfully added."
      redirect_to teams_path
    else
      render 'new'
    end
  end

  def update
    if @team.update(team_params)
      flash[:success] = "Team was successfully updated."
      redirect_to @team
    else
      render 'edit'
    end
  end

  def destroy
    @team.destroy
    flash[:success] = "Team was successfully deleted."
    redirect_to teams_url
  end
  
  private
    def set_team
      begin
        @team = Team.find(params[:id])
      rescue Exception => e
        redirect_to teams_path
        flash[:danger] = e
      end
    end
  
    def team_params
      params.require(:team).permit(:school, :name, :conference_id, :wins, :losses, :conference_wins, :conference_losses)
    end
end