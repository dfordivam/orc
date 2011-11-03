class CheckinsController < ApplicationController
  before_filter :login_required

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
    @event_list = Event.find(:all, :conditions => ["is_delete = ?", 0])
    @building_list = Building.find(:all, :conditions => ["is_delete = ?", 0])
    @coll = ["BK" , "Non BK"] #_visitor_types
  end

  def index
    @checkins = Checkin.find(:all, :conditions => ["is_delete = ?", 0]).paginate(:page => params[:page], :per_page => 15)
  end

  def show 
    @checkin = Checkin.find(params[:id])
  end

  def edit
    @checkin = Checkin.find(params[:id])
    @visitor = @checkin.visitor
    @event_list = Event.find(:all, :conditions => ["is_delete = ?", 0])
    @building_list = Building.find(:all, :conditions => ["is_delete = ?", 0])
    @rm_list = [""]
    @flr_list = [""]
  end

  def update
    temp_room = Room.find(:first, :conditions => ["is_delete = 0 and building_id = ? and floor = ? and room_no = ?",params[:room][:building_id],params[:fc1][:fc11],params[:rc1][:rc11]])

    if (temp_room.nil? == false) 
      if ! (temp_room.occupied_beds < temp_room.total_beds)
        flash[:notice] = "#ERROR#This room is full now !! Please select some other room. "
        redirect_to checkinfacebox_visitor_path(:visitor_id => params[:checkin][:visitor_id])
        return
      end
    else 
      flash[:notice] = "#ERROR#Wrong room specified, please try again.  "
      redirect_to checkinfacebox_visitor_path(:visitor_id => params[:checkin][:visitor_id])
      return
    end

    @checkin = Checkin.find(params[:id])
    room_old = @checkin.room
    @visitor = @checkin.visitor
    @event_list = Event.find(:all, :conditions => ["is_delete = ?", 0])
    @building_list = Building.find(:all, :conditions => ["is_delete = ?", 0])
    @rm_list = [""]
    @flr_list = [""]
    @checkin.room = temp_room
    if @checkin.update_attributes(params[:checkin])
      if @checkin.save
        @checkin.visitor.update_attribute(:checkin_date, @checkin.checkin_date)
        @checkin.visitor.update_attribute(:checkin_time, @checkin.checkin_time)
        @checkin.update_attribute(:is_accom_req, true)
        @checkin.update_attribute(:is_active, Date.today <= (@checkin.checkin_date + @checkin.no_of_days) && (Date.today >= @checkin.checkin_date))
        temp_room.update_attribute(:occupied_beds , temp_room.occupied_beds + 1)
        temp_room.update_attribute(:empty_beds , temp_room.total_beds - temp_room.occupied_beds)
        room_old.update_attribute(:occupied_beds , temp_room.occupied_beds - 1)
        room_old.update_attribute(:empty_beds , temp_room.total_beds - temp_room.occupied_beds)
        flash[:notice] = "Edit successful !!" 
        redirect_to checkins_path
      else
        flash[:notice] = "#ERROR#Edit Failed !! Please Provide All Valid Info !!"
        render 'edit'
      end
    else
      flash[:notice] = "#ERROR#Edit Failed !! Please Provide All Valid Info !!"
      render 'edit'
    end
  end

  def create
    temp_room = Room.where("is_delete = 0 AND building_id = ? AND floor = ? AND room_no = ?", params[:room][:building_id],params[:f1][:f11],params[:r1][:r11]).first

    if (temp_room.nil? == false) 
      if ! (temp_room.occupied_beds < temp_room.total_beds)
        flash[:notice] = "#ERROR#This room is full now !! Please select some other room. "
        redirect_to checkinfacebox_visitor_path(:visitor_id => params[:checkin][:visitor_id])
        return
      end
    else 
      flash[:notice] = "#ERROR#Wrong room specified, please try again.  "
      redirect_to checkinfacebox_visitor_path(:visitor_id => params[:checkin][:visitor_id])
      return
    end

    @checkin = Checkin.new(params[:checkin])
    @checkin.checkin_date = Date.today
    @checkin.checkin_time = Time.now.strftime("%H:%M:%S")
    @checkin.visitor_id = params[:checkin][:visitor_id]
    @checkin.event_id = params[:checkin][:event_id]
    @checkin.room = temp_room
    if params[:visitor]
      @visitor = Visitor.create(params[:visitor])
      @checkin.visitor = @visitor
    end
    if @checkin.save
      @checkin.visitor.update_attribute(:checkin_date, @checkin.checkin_date)
      @checkin.visitor.update_attribute(:checkin_time, @checkin.checkin_time)
      @checkin.update_attribute(:is_accom_req, true)
      @checkin.update_attribute(:is_active, Date.today <= (@checkin.checkin_date + @checkin.no_of_days) && (Date.today >= @checkin.checkin_date))
      temp_room.update_attribute(:occupied_beds , temp_room.occupied_beds + 1)
      temp_room.update_attribute(:empty_beds , temp_room.total_beds - temp_room.occupied_beds)
      flash[:notice] = "Check in successful !!"
      redirect_to visitors_path
    else
      flash[:notice] = "#ERROR#Check in fail !! Please try again !!"
      redirect_to visitors_path
    end
  end

  def destroy
    @checkin = Checkin.find(params[:id])
    if @checkin.room && @checkin.room.occupied_beds > 0 
      @checkin.room.update_attribute(:occupied_beds , @checkin.room.occupied_beds - 1)
      @checkin.room.update_attribute(:empty_beds , @checkin.room.total_beds - @checkin.room.occupied_beds)
    end
    ## @checkin.destroy
    @checkin.is_delete = 1
    @visitor = @checkin.visitor
    @visitor.update_attribute(:checkin_date, NIL)

    if @checkin.save 
      flash[:notice] = "Check In Record has been deleted" 
    else
      flash[:notice] = "#ERROR#Error in deleting record !!" 
    end
    redirect_to checkins_path
  end

  def inactivate
    @checkin = Checkin.find(params[:id])
    if @checkin
      @checkin.update_attribute(:is_active, 0)
      if @checkin.room && @checkin.room.occupied_beds > 0 
        @checkin.room.update_attribute(:occupied_beds , @checkin.room.occupied_beds - 1)
        @checkin.room.update_attribute(:empty_beds , @checkin.room.total_beds - @checkin.room.occupied_beds)
      end
    end
    redirect_to checkins_path
  end
end
