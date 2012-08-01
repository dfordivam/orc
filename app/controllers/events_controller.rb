require 'mime/types'
require 'spreadsheet'

class EventsController < ApplicationController

  before_filter :login_required

  load_and_authorize_resource

  Mime::Type.register "application/vnd.ms-excel", :xls
  
  def new
    @event = Event.new
  end
  
  def create
    @event = Event.new(params[:event])
    if !@event.start_date_time.nil? && !@event.end_date_time.nil? && @event.start_date_time > @event.end_date_time
      flash[:notice] = '#ERROR#Start date can\'t be more than end date'  
      render 'new'
    else
      if @event.save
         flash[:notice] = 'Done '
         redirect_to events_path
      else
         flash[:notice] = nil
         render 'new'
      end
    end
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      redirect_to events_path
    else
      render 'edit'
    end
  end

  def edit
    @event = Event.find(params[:id])
    @event.start_date_time=@event.start_date_time.strftime("%d %B %Y")
    @event.end_date_time=@event.end_date_time.strftime("%d %B %Y")
  end

  def show
    @event = Event.find(params[:id])
    @registrations = Registration.where(:event_id => params[:id], :is_delete => false).paginate(:page => params[:page], :per_page => 15)
    @participants = nil
    @registrations.each do |registration|
	@participants += registration.participants
    end
    #@participants = Registration.where(:event_id => params[:id], :is_delete => false).paginate(:page => params[:page], :per_page => 15)
    respond_to do |format|
      format.xls { create_excel_and_send( @event, @participants) }
      format.html { render :show }
    end
  end

  def destroy 
    @event = Event.find(params[:id])
    ## @event.destroy
    @event.is_delete = true
    if @event.save 
      temp_registration = Registration.find(:all,:conditions => ["event_id = ?", @event.id])
      temp_checkin = Checkin.find(:all,:conditions => ["event_id = ?", @event.id])
      for t_r in temp_registration
        t_r.update_attribute(:is_delete,true)
      end
      for t_c in temp_checkin
        t_c.update_attribute(:is_delete,true)
      end
      flash[:notice] = "Event #{@event.name} has been deleted" 
    else
      flash[:notice] = "#ERROR#Error in deleting event #{@event.name} " 
    end
    redirect_to events_path
  end    

  def index
    @events = Event.where(:is_delete => false).order("start_date_time DESC").paginate(:page => params[:page], :per_page => 15)
  end

  def participants
    @registrations = Registration.where(:event_id => params[:id], :is_delete => false).paginate(:page => params[:page], :per_page => 15)
    @participants += @registration.participants
#    @participants = [1,2]
  end

  def inactivate
    @event = Event.where(:id => params[:id], :is_delete => false).first
    if @event.nil? == false
      @event.update_attribute(:is_active, false)
    end
    redirect_to events_path
  end

  def activate
    @event = Event.where(:id => params[:id], :is_delete => false).first
    if @event.nil? == false
      @event.update_attribute(:is_active, true)
    end
    redirect_to events_path
  end

  
  def create_excel_and_send (event, participants)
    file_name = "#{event.name}.xls"
    file_book = Spreadsheet::Workbook.new
    file_sheet = file_book.create_worksheet(:name => "#{event.name}")
    
    write_excel(file_sheet, event, participants) 

    file_book.write "#{RAILS_ROOT}/public/downloads/#{file_name}"
    file_path = "#{RAILS_ROOT}/public/downloads/#{file_name}"
    send_file file_path, :type => 'application/vnd.ms-excel'
  end

  def write_excel(sheet, event, participants)
     row_counter = 0
     sheet.row(row_counter).default_format = Spreadsheet::Format.new(:weight=>"bold",:color=>"red",:pattern  => 1,:pattern_fg_color => "yellow")

     row_counter += 1
     sheet.row(row_counter).insert 0, "Name"
     sheet.row(row_counter).insert 1, event.name
#     sheet.row(row_counter).insert 3, "DOB"
#     sheet.row(row_counter).insert 4, visitor.dob.strftime("%d-%b-%Y")

     row_counter += 1
     sheet.row(row_counter).insert 0, "Start Date"
     sheet.row(row_counter).insert 1, event.start_date_time.strftime("%d-%b-%Y")
     sheet.row(row_counter).insert 3, "End Date"
     sheet.row(row_counter).insert 4, event.end_date_time.strftime("%d-%b-%Y")

     row_counter += 1
     sheet.row(row_counter).insert 0, "Capacity"
     sheet.row(row_counter).insert 1, event.capacity
     sheet.row(row_counter).insert 3, "Location"
     sheet.row(row_counter).insert 4, event.location


#     row_counter += 1
#     sheet.row(row_counter).insert 0, "Type"
#     sheet.row(row_counter).insert 1, visitor.visitor_type.upcase
#     sheet.row(row_counter).insert 3, "Email"
#     sheet.row(row_counter).insert 4, (visitor.email.nil? || @visitor.email=='') ? "N/A": @visitor.email
#     sheet.row(row_counter).insert 3, event_name
#     sheet.row(row_counter).insert 3, event_name

     row_counter += 2
     sheet.row(row_counter).default_format = Spreadsheet::Format.new(:weight=>"bold")
     sheet.row(row_counter).insert 0, "S.No."
     sheet.row(row_counter).insert 1, "Name"
     sheet.row(row_counter).insert 2, "Age"
     sheet.row(row_counter).insert 3, "Gender"
     sheet.row(row_counter).insert 4, "Mobile"
     sheet.row(row_counter).insert 5, "Visitor Type"
     sheet.row(row_counter).insert 6, "Address"
#     sheet.row(row_counter).insert 7, "CENTER NAME"
#     sheet.row(row_counter).insert 8, "ZONE"

     participants.length.times do |serial_no|
       participant = participants[serial_no].visitor
       row_counter += 1 
       sheet.row(row_counter).insert 0, (serial_no+1)
       sheet.row(row_counter).insert 1, participant.name
       sheet.row(row_counter).insert 2, participant.age
       sheet.row(row_counter).insert 3, participant.gender.capitalize
       sheet.row(row_counter).insert 4, participant.mobile_no
       sheet.row(row_counter).insert 5, participant.visitor_type
       sheet.row(row_counter).insert 6, participant.address
#       sheet.row(row_counter).insert 7, Centre.find_by_id(centres[serial_no].id).name
#       sheet.row(row_counter).insert 8, zones[serial_no].name
     end
  end
end
