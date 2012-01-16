require 'mime/types'
require 'spreadsheet'
require 'action_mailer'

class VisitorsController < ApplicationController
  before_filter :login_required

  autocomplete :visitor, :name, :extra_data => [:mobile_no, :age, :address, :gender]
  autocomplete :visitor, :mobile_no, :extra_data => [:name, :age, :address, :gender]

  def index
    @search_value  = params[:search_value]
    if @search_value
      @visitors = Visitor.search @search_value
    else 
      @visitors = Visitor.find(:all, :conditions => ["is_delete = ?", 0], :order => "name,address").paginate(:page => params[:page], :per_page => 15)
    end
  end

  def show
    @visitor = Visitor.find(params[:id], :conditions => ["is_delete = ?", 0])
    @registrations = @visitor.registrations.where(:is_delete => false)
  end

  def new
    @visitor = Visitor.new
    @visitor[:gender] = "male"
    @visitor[:is_physically_challenged] = 'false'
    @visitor[:is_guide] = 'false'
    @visitor[:is_driver_along] = 'false'
    @visitor[:is_driver_accom_req] = 'false'
    @visitor[:is_driver_in_gyan] = 'false'
    @visitor[:is_special_care_req] = 'false'
  end

  def edit
   # @event_list = Event.find(:all, :conditions => ["is_delete = ?", 0])
    @visitor = Visitor.find(params[:id], :conditions => ["is_delete = ?", 0])
    @visitor.dob= @visitor.dob.strftime("%d %B %Y")
  end

  def checkinfacebox
    @visitor = Visitor.find(params[:visitor_id], :conditions => ["is_delete = ?", 0])
    @checkin = Checkin.new
    @checkin.visitor = @visitor
    @building = Building.new
    @room = Room.new
    ## @event_list = Event.find(:all, :conditions => ["is_delete = ?", 0])
    @checkin.event = @visitor.event
    @building_list = Building.find(:all, :conditions => ["is_delete = ? and no_of_rooms > 0", 0])
    @room_list = [""]
    @floor_list = [""]
    @coll = ["BK" ,"Non BK" ,"Teacher" ,"Service" ] 
    render :layout => "aboutblank"
  end

  def create
    @visitor = Visitor.new(params[:visitor])
    @event_list = Event.find(:all, :conditions => ["is_delete = ?", 0])
    if @visitor.dob ==nil
      @visitor.dob = get_dob_from_age(@visitor.age)
    else
      @visitor.age = Time.now.strftime("%Y").to_i - (@visitor.dob.nil? ? Time.now.strftime("%Y").to_i : @visitor.dob.strftime("%Y").to_i)
    end
    if @visitor.save
      flash[:notice] = "Visitor #{@visitor.name.capitalize} successfully created"
      if params[:save]
        redirect_to visitors_path
      else
        redirect_to new_visitor_path
      end
    else
      flash[:notice] = nil
      render new_visitor_path
    end
  end

  def update
    @visitor = Visitor.find(params[:id])
    if @visitor.update_attributes(params[:visitor])
      flash[:notice] = "Visitor successfully updated"
      redirect_to visitors_path
    else
      render 'edit'
    end
  end

  def destroy
    @visitor = Visitor.find(params[:id])
    ## @visitor.destroy
    @visitor.is_delete = 1
    if @visitor.save 
      temp_checkin = Checkin.find(:all,:conditions => ["visitor_id = ?", @visitor.id])
      for t_c in temp_checkin
        t_c.update_attribute(:is_delete,1)
      end
      flash[:notice] = "Visitor #{@visitor.name} has been deleted" 
      redirect_to visitors_path
    else
      flash[:notice] = "#ERROR#Can not delete Visitor #{@visitor.name} " 
      redirect_to visitors_path
    end
  end

  def get_dob_from_age age
    dob_year = Time.now.strftime("%Y").to_i - age
    dob_mon = Time.now.strftime("%b")
    dob_time = dob_mon + " " + dob_year.to_s
    dob = Time.parse(dob_time)
    #return dob.strftime("%d%m%y")
    return dob.strftime("%Y-%m-%d")
  end

  # Adding form fields
  def add_fields_1
    render :partial => "add_fields"
  end

  # Adding form fields
  def add_fields_2
    render :partial => "add_fields2"
  end

  # Adding additional form fields
  def additional_info
    render :partial => "additional_info"
  end
end
