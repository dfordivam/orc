class RegistrationsController < ApplicationController
  before_filter :login_required

  def index
    @registrations = Registration.where(:is_delete => false)
  end

  def show
    @registration = Registration.where(:id => params[:id], :is_delete => false).first
  end

  def new
    visitor_id = params[:visitor_id]
    @event_list = Event.where(:is_delete => false)
    if (visitor_id.nil?)
      render visitors_path
    else
      visitor = Visitor.find(visitor_id)
      @registration = Registration.new
      @registration.visitor = visitor
    end
  end

  def create
    visitor_id = (params[:registration][:visitor_id])
    event_id = (params[:registration][:event_id])
    @existing_registration = Registration.where(:visitor_id => visitor_id, :event_id =>event_id , :is_delete => false).first
    if @existing_registration.nil?
      @registration = Registration.new(params[:registration])
      if @registration.save
        redirect_to registrations_path
      else
        render new_registration_path(:visitor_id => visitor_id)
      end
    else
      flash[:notice] = "#ERROR# Visitor is already registered "
      redirect_to registrations_path
    end
  end

  def edit
    @event_list = Event.where(:is_delete => false)
    @registration = Registration.where(:id => params[:id], :is_delete => false).first
  end

  def update
    @registration = Registration.find(params[:id])
    if @registration.update_attributes(params[:registration])
      flash[:notice] = "Registration successfully updated"
      redirect_to registrations_path
    else
      render edit_registration_path(params[:id])
    end  
  end

  def destroy
    @registration = Registration.find(params[:id])
    @registration.update_attribute(:is_delete, true)
     redirect_to registrations_path
  end
end
