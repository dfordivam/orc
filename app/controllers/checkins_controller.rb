class CheckinsController < ApplicationController
  def new
    @visitor = Visitor.find(params[:visitor_id])
    if (@visitor)
      @checkin = Checkin.new
      @checkin.visitor = @visitor
      @building = Building.new
      @room = Room.new
      @event_list = Event.find(:all)
      @building_list = Building.find(:all)
    else
      redirect_to visitors_path
    end
  end

  def index
    @checkins = Checkin.find(:all)
  end

  def create
    @checkin = Checkin.new(params[:checkin])
    @checkin.save
    redirect_to checkins_path
  end

  def destroy
    @checkin = Checkin.find(params[:id])
    @checkin.destroy
    redirect_to checkins_path
  end
end
