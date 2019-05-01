class StaticPagesController < ApplicationController
  before_action :logged_in_user, only: :admin
  before_action :admin_user, only: :admin
  
  def home
  end

  def help
  end
  
  def admin
  end
end
