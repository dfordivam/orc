class BuildingsController < ApplicationController
  def new
    @building = Building.new
  end

  def create
    @building = Building.new(params[:building])
    @building.save
  end

  def index
    @buildings = Building.find(:all)
  end

  def show
    @building = Building.find(params[:id])
  end

  def destroy
    @building = Building.find(params[:id])
    @building.destroy
  end

  def edit
    @building = Building.find(params[:id])
  end

  def update
    @building = Building.find(params[:id])
    if @building.update_attributes(params[:building])
      redirect_to buildings_path
    else
      render 'edit'
    end
  end
end
