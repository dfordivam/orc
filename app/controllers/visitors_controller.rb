require 'mime/types'
require 'spreadsheet'
require 'action_mailer'
class VisitorsController < ApplicationController
  before_filter :login_required

  def index
    @visitors = Visitor.find(:all).paginate(:page => params[:page], :per_page => 5)
  end

  def show
    @visitor = Visitor.find(params[:id])
  end

  def new
    @event_list = Event.find(:all)
    @visitor = Visitor.new
  end

  def edit
    @visitor = Visitor.find(params[:id])
  end

  def checkinfacebox
    # flash[:notice] = Visitor.find(params[:visitor_id]).name
    @visitor = Visitor.find(params[:visitor_id])
    @checkin = Checkin.new
    @checkin.visitor = @visitor
    @building = Building.new
    @room = Room.new
    @event_list = Event.find(:all)
    @building_list = Building.find(:all)
    @room_list = Room.find(:all)
    @coll = ["BK" , "Non BK"] 
    render :layout => "aboutblank"
    #render :layout => false
  end

  def create
    @visitor = Visitor.new(params[:visitor])
    if @visitor.save
      flash[:notice] = "New visitor successfully created"
      redirect_to visitors_path
    else
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
    @visitor.destroy
    redirect_to visitors_path
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
