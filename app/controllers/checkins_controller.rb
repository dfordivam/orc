class CheckinsController < ApplicationController
  def new
    @checkin = Checkin.new
    @building = Building.new
    @room = Room.new
    @event_list = Event.find(:all)
    @building_list = Building.find(:all)
  end

  def index
  end
  def create
    @checkin = Checkin.new(params[:checkin])
    @checkin.save
  end
  def roomsearch
    respond_to do |format|
      format.js do 
        render :text => 'hello'
      end
    end

  end
end
