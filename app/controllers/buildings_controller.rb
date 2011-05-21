class BuildingsController < ApplicationController
  def new
    @building = Building.new
  end
  def create
    @building = Building.new(params[:building])
    @building.save
  end
  def index
  end
end
