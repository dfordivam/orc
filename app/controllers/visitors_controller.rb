require 'mime/types'
require 'spreadsheet'
require 'action_mailer'

class VisitorsController < ApplicationController
  before_filter :login_required

  Mime::Type.register "application/vnd.ms-excel", :xls


  autocomplete :visitor, :name, :extra_data => [:mobile_no, :age, :address, :gender, :visitor_type, :id]
  autocomplete :visitor, :mobile_no, :extra_data => [:name, :age, :address, :gender, :visitor_type, :id]

  def get_autocomplete_items(parameters)
    items = super(parameters)
    items = items.where(:is_delete => false)
  end

  def index
    @search_value  = params[:search_value]
    if @search_value
      @visitors = Visitor.search @search_value, :conditions => { :is_delete => '0' }
    else 
      @visitors = Visitor.where(:is_delete => false).order(:name,:address).paginate(:page => params[:page], :per_page => 15)
    end
  end

  def show
    @visitor = Visitor.find(params[:id], :conditions => ["is_delete = ?", false])
    @registrations = @visitor.registrations.where(:is_delete => false)
    respond_to do |format|
      format.xls { create_excel_and_send( @visitor, @registrations ) }
      format.html { render :show }
      format.js { render :json => @visitor }
    end
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
#    @accompany_visitors = AccompanyVisitor.new
    @registration = Registration.new
    @registration.visitor = @visitor
    @event_list = Event.where(:is_delete => false, :is_active => true)
  end

  def edit
    @visitor = Visitor.find(params[:id], :conditions => ["is_delete = ?", 0])
    @visitor.dob = @visitor.dob.strftime("%d %B %Y")
  end

=begin
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
=end

  def create
    if params[:new_vis_reg_save] or params[:new_vis_reg_cont]
      @visitor = Visitor.new(params[:visitor])
      @event_list = Event.where(:is_delete => false, :is_active => true)
      
      if @visitor.dob == nil
        @visitor.dob = get_dob_from_age(@visitor.age)
      else
        @visitor.age = Time.now.strftime("%Y").to_i - (@visitor.dob.nil? ? Time.now.strftime("%Y").to_i : @visitor.dob.strftime("%Y").to_i)
      end

      if @visitor.save
        flash[:notice] = "Visitor #{@visitor.name.capitalize} successfully created"
      else
        flash[:notice] = nil
        render new_visitor_path
      end
    else
      visitor_id = (params[:registration][:visitor_id])
      @visitor = Visitor.where(:id => visitor_id, :is_delete => false).first
      event_id = (params[:registration][:event_id])
      @existing_registration = Registration.where(:visitor_id => visitor_id, :event_id =>event_id , :is_delete => false).first
      if @existing_registration.nil? == false
        flash[:notice] = "#ERROR# Visitor is already registered "
        redirect_to new_visitor_path
        return
      end
    end

    if @visitor.nil? == false
      @registration = Registration.new(params[:registration])
      @registration.visitor = @visitor
      if @registration.save
        unless params[:accompany_visitors].blank?
          params[:accompany_visitors].each do |accompany_visitor|
            acc_visitor = AccompanyVisitor.new(accompany_visitor)
            acc_visitor.registration_id = @registration.id
            acc_visitor.event_id = @registration.event_id
            acc_visitor.save
          end
        end
        if params[:new_vis_reg_save] or params[:reg_save]
          redirect_to registrations_path
        else
          redirect_to new_visitor_path
        end
      else
        render new_visitor_path
      end
    else
      render new_visitor_path
    end
  end

  def update
    @visitor = Visitor.find(params[:id])
    temp_visitor = Visitor.new(params[:visitor])

    puts ' temp ' + temp_visitor.dob.strftime("%D")
    puts ' old ' + @visitor.dob.strftime("%D")

    if temp_visitor.dob.strftime("%D") != @visitor.dob.strftime("%D")
      params[:visitor][:age] = Time.now.strftime("%Y").to_i - (temp_visitor.dob.nil? ? Time.now.strftime("%Y").to_i : temp_visitor.dob.strftime("%Y").to_i)
    else
      if temp_visitor.age != @visitor.age
        params[:visitor][:dob] = get_dob_from_age(temp_visitor.age)
      end
    end

    if @visitor.update_attributes(params[:visitor])
      flash[:notice] = "Visitor successfully updated"
      redirect_to visitors_path
    else
      render 'edit'
    end
  end

  def destroy
    @visitor = Visitor.find(params[:id])
    @visitor.is_delete = 1
    if @visitor.save 
      temp_registration = @visitor.registrations.where(:is_delete => false)
      temp_checkin = Checkin.find(:all,:conditions => ["visitor_id = ?", @visitor.id])
      for t_r in temp_registration
        t_r.update_attribute(:is_delete,1)
      end
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

  def create_excel_and_send (visitor, registrations)
    file_name = "#{visitor.name}.xls"
    file_book = Spreadsheet::Workbook.new
    file_sheet = file_book.create_worksheet(:name => "#{visitor.name}")
    
    write_excel(file_sheet, visitor, registrations) 

    file_book.write "#{RAILS_ROOT}/public/downloads/#{file_name}"
    file_path = "#{RAILS_ROOT}/public/downloads/#{file_name}"
    send_file file_path, :type => 'application/vnd.ms-excel'
  end

  def write_excel(sheet, visitor, registrations)
     row_counter = 0
     sheet.row(row_counter).default_format = Spreadsheet::Format.new(:weight=>"bold",:color=>"red",:pattern  => 1,:pattern_fg_color => "yellow")

     row_counter += 1
     sheet.row(row_counter).insert 0, "Name"
     sheet.row(row_counter).insert 1, visitor.name
     sheet.row(row_counter).insert 3, "DOB"
     sheet.row(row_counter).insert 4, visitor.dob.strftime("%d-%b-%Y")

     row_counter += 1
     sheet.row(row_counter).insert 0, "Address"
     sheet.row(row_counter).insert 1, visitor.address
     sheet.row(row_counter).insert 3, "Age"
     sheet.row(row_counter).insert 4, visitor.age

     row_counter += 1
     sheet.row(row_counter).insert 0, "Gender"
     sheet.row(row_counter).insert 1, visitor.gender.downcase == "female" ? "Female" : "Male"
     sheet.row(row_counter).insert 3, "Contact No."
     sheet.row(row_counter).insert 4, visitor.mobile_no


     row_counter += 1
     sheet.row(row_counter).insert 0, "Type"
     sheet.row(row_counter).insert 1, visitor.visitor_type.upcase
     sheet.row(row_counter).insert 3, "Email"
     sheet.row(row_counter).insert 4, (visitor.email.nil? || @visitor.email=='') ? "N/A": @visitor.email
#     sheet.row(row_counter).insert 3, event_name
#     sheet.row(row_counter).insert 3, event_name

     row_counter += 2
     sheet.row(row_counter).default_format = Spreadsheet::Format.new(:weight=>"bold")
     sheet.row(row_counter).insert 0, "S.No."
     sheet.row(row_counter).insert 1, "Event"
     sheet.row(row_counter).insert 2, "Registration Date"
     sheet.row(row_counter).insert 3, "Accompanying Male"
     sheet.row(row_counter).insert 4, "Accompanying Female"
#     sheet.row(row_counter).insert 5, ")"
#     sheet.row(row_counter).insert 6, "CENTER ADDRESS"
#     sheet.row(row_counter).insert 7, "CENTER NAME"
#     sheet.row(row_counter).insert 8, "ZONE"

     registrations.length.times do |serial_no|
       registration = registrations[serial_no]
       row_counter += 1 
       sheet.row(row_counter).insert 0, (serial_no+1)
       sheet.row(row_counter).insert 1, registration.event.name
       sheet.row(row_counter).insert 2, registration.created_at.strftime("%d-%b-%Y")
       sheet.row(row_counter).insert 3, registration.accompanying_males.nil? ? '0' : registration.accompanying_males
       sheet.row(row_counter).insert 4, registration.accompanying_females.nil? ? '0' : registration.accompanying_females
#       sheet.row(row_counter).insert 5, participants[serial_no].in_gyan
#       sheet.row(row_counter).insert 6, addresses[serial_no].addr1
#       sheet.row(row_counter).insert 7, Centre.find_by_id(centres[serial_no].id).name
#       sheet.row(row_counter).insert 8, zones[serial_no].name
     end
  end

end
