class StaticPagesController < ApplicationController
  before_action :logged_in_user, only: :admin
  before_action :admin_user, only: :admin
  
  def home
    if logged_in?
      redirect_to dashboard_path
    end
  end

  def help
  end
  
  def admin
  end
  
  def dashboard
    @seasons = TeamSeason.where(season: current_season).order(adj_efficiency_margin: :desc).first(50)
    @blog_posts = BlogPost.order(date: :desc).first(5)
    @games = Game.where(day: Date.today)
  end
end
