class BuildingsController < ApplicationController
  before_filter :login_required
  load_and_authorize_resource
  
  def new
    @building = Building.new
  end

  def create
    @building = Building.new(params[:building])
    @building.no_of_rooms = 0
    if @building.save
      redirect_to buildings_path 
    else
      flash[:notice] = "Error in creating Building"
      render 'new'
    end
  end

  def index
    @buildings = Building.find(:all, :conditions => ["is_delete = ?", false], :order => "name").paginate(:page => params[:page], :per_page => 15)
    #@buildings = Building.order("name").paginate(:page => params[:page], :per_page => 15)
  end

  def show
    @building = Building.find(params[:id])
    @room = Room.find(:all,:conditions => ["building_id = ? and is_delete = 0", @building.id], :order => "floor, room_no")
  end

  def destroy
    @building = Building.find(params[:id])
    ## @building.destroy
    @building.is_delete = 1
    if @building.save 
      temp_room = Room.find(:all,:conditions => ["building_id = ? and is_delete = 0", @building.id])
      for t_r in temp_room
        t_r.update_attribute(:is_delete,1)
        temp_checkin = Checkin.find(:all, :conditions => ["room_id = ? and is_delete = 0", t_r.id])
        for t_c in temp_checkin
          t_c.update_attribute(:is_delete, 1)
          visitor = t_c.visitor
          visitor.update_attribute(:checkin_date, NIL)
        end
      end
      flash[:notice] = "Building #{@building.name} has been deleted" 
    else
      flash[:notice] = "#ERROR#Can not delete Building #{@building.name} " 
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

  def add_rooms_to_building
    @building = Building.find(params[:building_id], :order => "floors")
    @room = Room.new(:building => @building)
    @floor_list = [""]
    @building.floors.times do |fl|
      @floor_list << fl.to_s
    end
    @room_category = [1, 2]
  end

  def add_rooms_to_building_view
    @building = Building.find(params[:building_id])
    params[:room][:building] = @building
    @room = Room.new(params[:room])
    tot_beds = @room.total_beds||0
    occup_beds = @room.occupied_beds||0
    @room.empty_beds = tot_beds - occup_beds
    @floor_list = [""]
    @building.floors.times do |fl|
      @floor_list << fl.to_s
    end
    @room_category = [1, 2]
    if tot_beds < occup_beds
      flash[:notice] = "#ERROR# #{@room.occupied_beds}Total beds can't be less than occupied beds "
      render 'add_rooms_to_building'
      return
    end
    if @room.save
      @building.update_attribute(:no_of_rooms , @building.no_of_rooms + 1)
      flash[:notice] = "Rooms added successfully to #{@building.name}"
      redirect_to buildings_path
    else
      flash[:notice] = nil
      render 'add_rooms_to_building'
    end
  end

end
