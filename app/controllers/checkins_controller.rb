class CheckinsController < ApplicationController
  def new
    if (params[:visitor_id])
      @visitor = Visitor.find(params[:visitor_id])
    else
      @visitor = Visitor.new
    end
    @checkin = Checkin.new
    @checkin.visitor = @visitor
    @building = Building.new
    @room = Room.new
    @event_list = Event.find(:all)
    @building_list = Building.find(:all)
    @coll = ["BK" , "Non BK"] #_visitor_types
  end

  def index
    @checkins = Checkin.find(:all)
  end

  def show 
    @checkin = Checkin.find(params[:id])
  end

  def edit
    @checkin = Checkin.find(params[:id])
    @event_list = Event.find(:all)
    @building_list = Building.find(:all)
  end

  def update
    @checkin = Checkin.find(params[:id])
    if @checkin.update_attributes(params[:checkin])
      redirect_to checkins_path
    else
      render 'edit'
    end
  end

  def create
    @checkin = Checkin.new(params[:checkin])
    if params[:visitor]
      @visitor = Visitor.create(params[:visitor])
      @checkin.visitor = @visitor
    end
    @checkin.room.update_attribute(:occupied_beds , @checkin.room.occupied_beds + 1)
    @checkin.room.update_attribute(:empty_beds , @checkin.room.total_beds - @checkin.room.occupied_beds)
    @checkin.save
    redirect_to checkins_path
  end

  def destroy
    @checkin = Checkin.find(params[:id])
    if @checkin.room && @checkin.room.occupied_beds > 0 
      @checkin.room.update_attribute(:occupied_beds , @checkin.room.occupied_beds - 1)
      @checkin.room.update_attribute(:empty_beds , @checkin.room.total_beds - @checkin.room.occupied_beds)
    end
    @checkin.destroy
    redirect_to checkins_path
  end

  def inactivate
    @checkin = Checkin.find(params[:id])
    if @checkin
      @checkin.update_attribute(:is_active, 0)
    end
    redirect_to checkins_path
  end
end
