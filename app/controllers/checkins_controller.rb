class CheckinsController < ApplicationController
  def new
    @checkin = Checkin.new
    @building = Building.new
    @room = Room.new
    @event_list = Event.find(:all)
    @building_list = Building.find(:all)
  end

  def index
    @checkins = Checkin.find(:all)
  end

  def create
    @checkin = Checkin.new(params[:checkin])
    @checkin.save
  end
end
