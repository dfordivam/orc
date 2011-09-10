class RoomsController < ApplicationController
  before_filter :login_required
  def new
    @building = Building.find(params[:building_id])
    if @building
      @room = Room.new(:building => @building)
      @room_category = [1, 2]
    else
      redirect_to buildings_path
    end
  end

  def create
    #HACK- need to send building info from the form
    @building = Building.find(params[:room][:building])
    params[:room][:building] = @building
    @room = Room.new(params[:room])
    @room.empty_beds = @room.total_beds - @room.occupied_beds
    if @room.save
      redirect_to building_path(@building.id)
    else
      redirect_to new_room_path
    end
  end

  def index
    @rooms = Room.find(:all, :conditions => ["is_delete = ?", 0])
  end

  def show 
    @room = Room.find(params[:id])
  end

  def destroy 
    @room = Room.find(params[:id])
    ## @room.destroy
    @room.is_delete = 1
    if @room.save 
      flash[:notice] = "Room #{@room.room_no} has been deleted" 
    else
      flash[:notice] = "Error in deleting room #{@room.room_no} !!" 
    end
    redirect_to building_path(@room.building.id)
  end

  def edit 
    @room = Room.find(params[:id])
  end

  def update
    @room = Room.find(params[:id])
    if @room.update_attributes(params[:room])
      redirect_to rooms_path
    else
      render 'edit'
    end
  end
end
