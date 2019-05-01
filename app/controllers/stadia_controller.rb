class StadiaController < ApplicationController
  def new
    @stadium = Stadium.new
  end
end
