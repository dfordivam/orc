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

  def list
  end

  def create
    #HACK- need to send building info from the form
    @building = Building.find(params[:room][:building])
    params[:room][:building] = @building
    @room = Room.new(params[:room])
    if @room.save
      redirect_to buildings_path
    else
      redirect_to new_room_path
    end
  end
end
