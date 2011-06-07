class RoomsController < ApplicationController
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
      redirect_to buildings_path
    else
      redirect_to new_room_path
    end
  end

  def index
    @rooms = Room.find(:all)
  end

  def show 
    @room = Room.find(params[:id])
  end

  def destroy 
    @room = Room.find(params[:id])
    @room.destroy
  end

  def edit 
    @room = Room.find(params[:id])
  end

  def update
  end
end
