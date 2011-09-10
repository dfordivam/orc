class BuildingsController < ApplicationController
  before_filter :login_required
  load_and_authorize_resource
  
  def new
    @building = Building.new
  end

  def create
    @building = Building.new(params[:building])
    @building.save
    redirect_to buildings_path
  end

  def index
    @buildings = Building.find(:all, :conditions => ["is_delete = ?", 0])
  end

  def show
    @building = Building.find(params[:id])
  end

  def destroy
    @building = Building.find(params[:id])
    ## @building.destroy
    @building.is_delete = 1
    if @building.save 
      flash[:notice] = "Building #{@building.name} has been deleted" 
    else
      flash[:notice] = "Can not delete Building #{@building.name} !!" 
    end
    redirect_to buildings_path
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
