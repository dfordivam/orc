class UtilitiesController < ApplicationController
  require 'mime/types'
  require 'spreadsheet'

  def index
  end

  def user_list
  end

  def cancel_building
    flash[:notice] = nil
    render 'index'
  end

  def cancel_user
    flash[:notice] = nil
    render 'index'
  end

  def cancel_event
    flash[:notice] = nil
    render 'index'
  end

  def download_user_list
    handleDownloadUserList
    return
  end

  def download_building_list
    handleDownloadBuildingList
    return
  end

  def download_event_list
    handleDownloadEventList
    return
  end

  def download_visitor_list
    handleDownloadVisitorList
    return
  end

  def building_load
    flash[:notice] = nil
    unique_file_name = params[:id]
    ##directory = "#{RAILS_ROOT}/public/uploads/building_list"
    directory = "#{RAILS_ROOT}/tmp"
    full_file_name = File.join(directory,unique_file_name)
    buildings_rooms = extract_buildings_from_excel(full_file_name)
    successful_loaded_rooms = 0
    buildings_rooms.length.times do |br|
      if ! buildings_rooms[br][:isbad]
        temp_build = Building.find_by_sql("select * from buildings where is_delete = 0 and upper(name) = upper('#{buildings_rooms[br][:building_name]}')")
        temp_build_id = temp_build[0].nil? ? nil : temp_build[0][:id]
        if temp_build[0].nil?
          new_building = Building.new(:name => buildings_rooms[br][:building_name], :no_of_rooms => 0, :floors => 0, :is_delete => 0)
          if new_building.save
            temp_build_id = new_building[:id]
          else
            flash[:notice] = "#ERROR#Fatal Error (#{new_building.errors.full_messages[0]||''}) While Saving Building. Contact Admin !! Reference: #{unique_file_name}"
          end
        end
        new_old_building = Building.find(:first, :conditions => ["id = ? and is_delete = 0",temp_build_id])
        temp_room = Room.new()
        temp_room[:floor] = buildings_rooms[br][:floor]
        temp_room[:category] = buildings_rooms[br][:category]
        temp_room.building = new_old_building
        temp_room[:room_no] = buildings_rooms[br][:room_name].to_i == 0 ? buildings_rooms[br][:room_name] : buildings_rooms[br][:room_name].to_i
        temp_room[:total_beds] = buildings_rooms[br][:total_beds]
        temp_room[:is_delete] = 0 
        if temp_room.save
          temp_room.update_attribute(:is_ac,buildings_rooms[br][:is_ac])
          temp_room.update_attribute(:is_extensible,buildings_rooms[br][:is_extensible])
          temp_room.update_attribute(:beds_extensible,buildings_rooms[br][:beds_extensible]||0)
          temp_room.update_attribute(:occupied_beds,buildings_rooms[br][:occupied_beds]||0)
          temp_room.update_attribute(:empty_beds,"#{buildings_rooms[br][:occupied_beds].nil? ? buildings_rooms[br][:total_beds] : buildings_rooms[br][:total_beds].to_i - buildings_rooms[br][:occupied_beds].to_i}")
          no_of_rooms_in_building = Room.find_by_sql("select count(room_no) as ct from rooms where is_delete = 0 and building_id = #{temp_build_id}")
          no_of_floors_in_building = Room.find_by_sql("select max(floor) as flr from rooms where is_delete = 0 and building_id= #{temp_build_id}")
          new_old_building.update_attribute(:no_of_rooms,no_of_rooms_in_building[0][:ct])
          new_old_building.update_attribute(:floors,no_of_floors_in_building[0][:flr])
          successful_loaded_rooms += 1
        else
          flash[:notice] = "#ERROR#Fatal Error (#{temp_room.errors.full_messages[0]||''}) While Saving Rooms. Contact Admin !! Reference: #{unique_file_name}"
        end
      end
    end
    flash[:notice] = flash[:notice]||"#{ successful_loaded_rooms==0 ? 'No ' : successful_loaded_rooms} Records Loaded Successfully !!"
    render 'index'
  end

  def visitor_load
    flash[:notice] = nil
    unique_file_name = params[:id]
    ##directory = "#{RAILS_ROOT}/public/uploads/visitor_list"
    directory = "#{RAILS_ROOT}/tmp"
    full_file_name = File.join( directory, unique_file_name)
    visitors = extract_visitors_from_excel(full_file_name)

    @successful_loaded = 0
    visitors.each do |visitor|
      if ! visitor[:isbad]
        event_name = visitor[:event]
        event = Event.where(:name => event_name).first
        visitor[:event] = event
        visitor.delete(:isbad)
        visitor.delete(:comment)
        @new_visitor = Visitor.new(visitor)
        if @new_visitor.save
          @successful_loaded += 1
        else
          flash[:notice] = "#ERROR#Fatal Error (#{@new_visitor.errors.full_messages[0]||''}) in Visitors. Please Contact Admin. Reference: #{unique_file_name}"
        end
      end
    end  
    flash[:notice] = flash[:notice]||"#{ @successful_loaded ==0 ? 'No ' : @successful_loaded} Records Loaded Successfully !!"
    render 'index'
  end

  def usr_load
    flash[:notice] = nil
    unique_file_name = params[:id]
    ##directory = "#{RAILS_ROOT}/public/uploads/user_list"
    directory = "#{RAILS_ROOT}/tmp"
    full_file_name = File.join(directory,unique_file_name)
    users = extract_users_from_excel(full_file_name)
    @successful_loaded_users = 0
    users.length.times do |us|
      if ! users[us][:isbad]
        @new_user = User.new()
        @new_user.username = users[us][:username]
        @new_user.email = users[us][:email]
        @new_user.role_id = users[us][:role_id]
        @new_user.password = users[us][:password]
        @new_user.password_confirmation = users[us][:password]
        if @new_user.save
          @successful_loaded_users += 1
          user_roles = UsersRoles.new()
          user_roles.user_id = @new_user.id
          user_roles.role_id = @new_user.role_id
          if ! user_roles.save
            flash[:notice] = "#ERROR#Fatal Error (#{user_roles.errors.full_messages[0]||''}) in USERS_ROLES!! Contact Admin !! Reference: #{unique_file_name}"
          end
        else
          flash[:notice] = "#ERROR#Fatal Error (#{@new_user.errors.full_messages[0]||''}) in USERS!! Contact Admin !! Reference: #{unique_file_name}"
        end
      end
    end  
    flash[:notice] = flash[:notice]||"#{ @successful_loaded_users==0 ? 'No ' : @successful_loaded_users} Records Loaded Successfully !!"
    render 'index'
  end

  def event_load
    flash[:notice] = nil
    unique_file_name = params[:id]
    ##directory = "#{RAILS_ROOT}/public/uploads/event_list"
    directory = "#{RAILS_ROOT}/tmp"
    full_file_name = File.join(directory,unique_file_name)
    events = extract_events_from_excel(full_file_name)
    @successful_loaded_events = 0
   events.length.times do |event|
      if ! events[event][:isbad]
        @new_event = Event.new()
        @new_event.name = events[event][:event_name]
        @new_event.start_date_time = events[event][:event_start_date]
        @new_event.end_date_time = events[event][:event_end_date]
        @new_event.location = events[event][:location]
        @new_event.capacity = events[event][:capacity].to_i
        @new_event.is_delete = 0
        if @new_event.save
          @successful_loaded_events += 1
        else
          flash[:notice] = "#ERROR#Fatal Error (#{@new_event.errors.full_messages[0]||''}) in Events. Please Contact Admin. Reference: #{unique_file_name}"
        end
      end
    end
    flash[:notice] = flash[:notice]||"#{ @successful_loaded_events ==0 ? 'No ' : @successful_loaded_events} Records Loaded Successfully !!"
    render 'index'
  end

  def uploadexcel
    # file_name_user_list = params[:upload_user_list_file][:user_list_file]||"No File !!"
    # file_name_building_list = params[:upload_building_list_file][:building_list_file]||"No File !!"
    # file_name_event_list = params[:upload_event_list_file][:event_list_file]||"No File !!"
    # params[:id] in {upload_user_list,upload_building_list,upload_event_list,download_user_list,download_building_list,download_event_list}
    flash[:notice] = nil
    if (! params[:upload_user_list_file].nil?) && (! params[:upload_user_list_file][:user_list_file].nil?)
      file = params[:upload_user_list_file][:user_list_file]
      handleUploadUserList(file)
      return
    elsif (! params[:upload_visitor_list_file].nil?) && (! params[:upload_visitor_list_file][:visitor_list_file].nil?)
      file = params[:upload_visitor_list_file][:visitor_list_file]
      handleUploadVisitorList(file)
      return
    elsif (! params[:upload_building_list_file].nil?) && (! params[:upload_building_list_file][:building_list_file].nil?)
      file = params[:upload_building_list_file][:building_list_file]
      handleUploadBuildingList(file)
      return
    elsif (! params[:upload_event_list_file].nil?) && (! params[:upload_event_list_file][:event_list_file].nil?)
      file = params[:upload_event_list_file][:event_list_file]
      handleUploadEventList(file)
      return
    else
      flash[:notice] = "#ERROR# Please choose the file first and then upload !!"
      render 'index'
    end
    return
  end

  private

  def check_users_for_errors(users)
    email_list = User.find_by_sql("select distinct trim(email) as email from users where is_delete = 0")
    users.length.times do |us|
      existing_user = User.find(:first,:conditions => ["username = ?", users[us][:username]])
      if users[us][:username].nil? || users[us][:email].nil? || users[us][:role_id].nil? || users[us][:password].nil? || users[us][:role].nil?
        users[us][:isbad] = true
        users[us][:comment] = "No Fields Should Be Blank !!"
      end
      if ! email_list.detect{|em| em.email == users[us][:email]}.nil?
        users[us][:isbad] = true
        users[us][:comment] = "Email already exists !!"
      end
      if users[us][:username].length < 5
        users[us][:isbad] = true
        users[us][:comment] = "Name length must by > 5 !!"
      end
      if ! existing_user.nil?
        users[us][:isbad] = true
        users[us][:comment] = "Username already taken !!"
      end
    end 
  end


  def check_events_for_errors(events)
    events.each do |event|
      if event[:event_name].nil? || event[:event_start_date].nil? || event[:event_end_date].nil? || event[:capacity].nil? || event[:location].nil? 
        event[:isbad] = true
        event[:comment] = "Give All Mandatory Fields"
      end 
    end
  end



  def check_visitors_for_errors(visitors)
    visitors.each do |visitor|
      if visitor[:name].nil? || visitor[:gender].nil? || visitor[:dob].nil? || visitor[:address].nil? || visitor[:mobile_no].nil? || visitor[:event].nil? || visitor[:visitor_type].nil?
        visitor[:isbad] = true
        visitor[:comment] = "Give All Mandatory Fields"
      end 

      if (visitor[:visitor_type]) && (visitor[:visitor_type] == 'bk')
        if (visitor[:in_gyan_years] && visitor[:in_gyan_years].to_i && visitor[:centre_addr])
        else
          visitor[:isbad] = true
          visitor[:comment] = "Give 'In Gyan years' and 'Centre Address' "
        end
      end
    end
  end

  def check_buildings_for_errors(buildings_rooms)
    buildings_rooms.length.times do |br|
      if (buildings_rooms[br][:is_extensible]) && (buildings_rooms[br][:beds_extensible].nil?)
        buildings_rooms[br][:isbad] = true
        buildings_rooms[br][:comment] = "Give Beds Extensible"
      end
      if buildings_rooms[br][:building_name].nil? || buildings_rooms[br][:floor].nil? || buildings_rooms[br][:room_name].nil? || buildings_rooms[br][:is_ac].nil? || buildings_rooms[br][:total_beds].nil? || buildings_rooms[br][:category].nil? || buildings_rooms[br][:is_extensible].nil?
        buildings_rooms[br][:isbad] = true
        buildings_rooms[br][:comment] = "Give All Fields"
      end 
      if ! buildings_rooms[br][:building_name].nil?
        temp_build = Building.find_by_sql("select * from buildings where is_delete = 0 and upper(name) = upper('#{buildings_rooms[br][:building_name]}')")
        if (! temp_build[0].nil?) && (! buildings_rooms[br][:floor].nil?) && (! buildings_rooms[br][:room_name].nil?)
          temp_build_id = temp_build[0][:id]
          temp_room_no = "#{buildings_rooms[br][:room_name].to_i == 0 ? buildings_rooms[br][:room_name] : buildings_rooms[br][:room_name].to_i}"
          temp_rec = Room.find_by_sql("select * from rooms where is_delete = 0 and floor = #{buildings_rooms[br][:floor]} and upper(room_no) = upper('#{temp_room_no}') and building_id = #{temp_build_id}")
          if ! temp_rec[0].nil?
            buildings_rooms[br][:isbad] = true
            buildings_rooms[br][:comment] = "Room Exists !!"
          end
        end
      end
    end
  end

  def extract_users_from_excel(full_file_name)
    flash[:notice] = nil
    list_header = ["UserName","Email","Password","UserRole"]
    record_counter = 0
    @users = []
    book = Spreadsheet.open full_file_name
    @sheet1 = book.worksheet 0
    first_row = @sheet1.row(0)
    if first_row == list_header
      @sheet1.each 1 do |row|
        if (! row.nil?) && (! row[0].nil?) then
          record_counter += 1
          roleID = row[3] == "admin" ? 1 : (row[3] == "moderator" ? 2 : 3)
          @users.insert(-1,{:username=>row[0],:email=>row[1],:role_id=>roleID,:password=>row[2],:role=>row[3],:isbad=>false,:comment=>"All Valid Fields"})
        end
      end
      check_users_for_errors(@users)
    else
      flash[:notice] = "#ERROR#Missing Header Record . Kindly refer the template!!"
    end
    return @users
  end

  def extract_visitors_from_excel(full_file_name)
    flash[:notice] = nil
    list_header = ["Name", "Gender", "Age", "Address", "Mobile", "Event", "BK?", "In Gyan (Years)", "Centre"]
    record_counter = 0
    @visitors = []
    book = Spreadsheet.open full_file_name
    @sheet1 = book.worksheet 0
    first_row = @sheet1.row(0)
    if first_row == list_header
      @sheet1.each 1 do |row|
        if (! row.nil?) && (! row[0].nil?) then
          record_counter += 1
          @visitors.insert(-1, {
            :name => row[0],
            :gender => row[1].capitalize,
            :dob => get_dob_from_age(row[2].to_i),
            :age => row[2],
            :address => row[3],
            :mobile_no => row[4].to_i,
            :event => row[5],
            :visitor_type => (row[6] == 'yes')? 'bk' : 'non_bk',
            :in_gyan_years => row[7],
            :centre_addr => row[8],
            :is_physically_challenged => 'false',
            :isbad => false,
            :comment => "All Valid Fields"
          })
        end
      end
      check_visitors_for_errors(@visitors)
    else
      flash[:notice] = "#ERROR#Missing Header Record . Kindly refer the template!!"
    end
    return @visitors
  end

def extract_events_from_excel(full_file_name)
    flash[:notice] = nil
    list_header = ["EventName", "EventStartDate", "EventEndDate", "Capacity", "Location"]
    record_counter = 0
    @events = []
    book = Spreadsheet.open full_file_name
    @sheet1 = book.worksheet 0
    first_row = @sheet1.row(0)
    if first_row == list_header
      @sheet1.each 1 do |row|
        if (! row.nil?) && (! row[0].nil?) then
          record_counter += 1
          @events.insert(-1, {
            :event_name => row[0],
            :event_start_date => row[1],
            :event_end_date => row[2],
            :capacity => row[3],
            :location => row[4],
            :comment => "All Valid Fields",
            :isbad => false
          })
        end
      end
      check_events_for_errors(@events)
    else
      flash[:notice] = "#ERROR#Missing Header Record . Kindly refer the template!!"
    end
    return @events
  end

  def extract_buildings_from_excel(full_file_name)
    flash[:notice] = nil
    list_header = ["BuildingName","Floor","RoomNumberORName","IsAC","IsExtensible","BedsExtensible","TotalBeds","OccupiedBeds","Category"]
    record_counter = 0
    @buildings_rooms = []
    book = Spreadsheet.open full_file_name
    @sheet1 = book.worksheet 0
    first_row = @sheet1.row(0)
    if first_row == list_header
      @sheet1.each 1 do |row|
        if (! row.nil?) && (! row[0].nil?) then
          record_counter += 1
          @buildings_rooms.insert(-1,
                                  {:building_name => row[0],
                                    :floor => row[1],
                                    :room_name => row[2],
                                    :is_ac => row[3],
                                    :is_extensible => row[4],
                                    :beds_extensible => row[5],
                                    :total_beds => row[6],
                                    :occupied_beds => row[7],
                                    :category => row[8],
                                    :isbad => false,
                                    :comment => "All Valid Fields"
          }
                                 )
        end
      end
      check_buildings_for_errors(@buildings_rooms)
    else
      flash[:notice] = "#ERROR#Missing Header Record . Kindly refer the template!!"
    end
    return @buildings_rooms
  end

  def handleUploadUserList(file)
    if ! file.nil?
      if (file.content_type && (file.content_type.chomp == "application/vnd.ms-excel" || file.content_type.chomp == "application/octet-stream"))
        @unique_file_name = save_file(file,"user_list")
        ## @full_file_name = "#{RAILS_ROOT}/public/uploads/user_list/#{ @unique_file_name}"
        @full_file_name = "#{RAILS_ROOT}/tmp/#{ @unique_file_name}"
        @users = extract_users_from_excel(@full_file_name)
        if flash[:notice].nil?
          render 'user_list'
        else
          render 'index'
        end
      else
        flash[:notice] = "#ERROR#File type (#{file.content_type.chomp}) error. Please upload MS-Excel File !!"
        render 'index'
      end
    else
      flash[:notice] = file.original_filename||"#ERROR# Please choose the file first and then upload !!"
      render 'index'
    end
  end

  def handleUploadVisitorList(file)
    if ! file.nil?
      if (file.content_type && (file.content_type.chomp == "application/vnd.ms-excel" || file.content_type.chomp == "application/octet-stream"))
        @unique_file_name = save_file(file,"visitor_list")
        ## @full_file_name = "#{RAILS_ROOT}/public/uploads/visitor_list/#{ @unique_file_name}"
        @full_file_name = "#{RAILS_ROOT}/tmp/#{ @unique_file_name}"
        @visitors = extract_visitors_from_excel(@full_file_name)
        if flash[:notice].nil?
          render 'visitor_list'
        else
          render 'index'
        end
      else
        flash[:notice] = '#ERROR#File type (#{file.content_type.chomp})error. Please upload MS-Excel File !!'
        render 'index'
      end
    else
      flash[:notice] = file.original_filename||"#ERROR# Please choose the file first and then upload !!"
      render 'index'
    end
  end

  def handleUploadBuildingList(file)
    if ! file.nil?
      if (file.content_type && (file.content_type.chomp == "application/vnd.ms-excel" || file.content_type.chomp == "application/octet-stream"))
        @unique_file_name = save_file(file,"building_list")
        ## @full_file_name = "#{RAILS_ROOT}/public/uploads/building_list/#{ @unique_file_name}"
        @full_file_name = "#{RAILS_ROOT}/tmp/#{ @unique_file_name}"
        @buildings_rooms = extract_buildings_from_excel(@full_file_name)
        if flash[:notice].nil?
          render 'building_list'
        else
          render 'index'
        end
      else
        flash[:notice] = '#ERROR#File type (#{file.content_type.chomp})error. Please upload MS-Excel File !!'
        render 'index'
      end
    else
      flash[:notice] = file.original_filename||"#ERROR# Please choose the file first and then upload !!"
      render 'index'
    end
  end

  def handleUploadEventList(file)
   if ! file.nil?
      if (file.content_type && (file.content_type.chomp == "application/vnd.ms-excel" || file.content_type.chomp == "application/octet-stream"))
        @unique_file_name = save_file(file,"event_list")
        ## @full_file_name = "#{RAILS_ROOT}/public/uploads/event_list/#{ @unique_file_name}"
        @full_file_name = "#{RAILS_ROOT}/tmp/#{ @unique_file_name}"
        @events = extract_events_from_excel(@full_file_name)
        if flash[:notice].nil?
          render 'event_list'
        else
          render 'index'
        end
      else
        flash[:notice] = '#ERROR#File type (#{file.content_type.chomp})error. Please upload MS-Excel File !!'
        render 'index'
      end
    else
      flash[:notice] = file.original_filename||"#ERROR# Please choose the file first and then upload !!"
      render 'index'
    end 
  end

  def save_file(file,folder)
    ##directory = "#{RAILS_ROOT}/public/uploads/#{folder}"
    directory = "#{RAILS_ROOT}/tmp"
    unique_file_name = "#{Time.now.to_s.gsub(/[: +]/,'_')}_#{file.original_filename}"
    path = File.join(directory,unique_file_name)
    File.open(path, "wb") { |f| f.write(file.read) }
    return unique_file_name
  end

  def handleDownloadUserList
    file = "UsersList_Template.xls"
    file_path = "#{RAILS_ROOT}/public/downloads/#{file}"
    send_file file_path, :type => 'application/vnd.ms-excel'
  end

  def handleDownloadVisitorList
    file = "VisitorList_Template.xls"
    file_path = "#{RAILS_ROOT}/public/downloads/#{file}"
    send_file file_path, :type => 'application/vnd.ms-excel'
  end

  def handleDownloadBuildingList
    file = "BuildingList_Template.xls"
    file_path = "#{RAILS_ROOT}/public/downloads/#{file}"
    send_file file_path, :type => 'application/vnd.ms-excel'
  end

  def handleDownloadEventList
    file = "EventList_Template.xls"
    file_path = "#{RAILS_ROOT}/public/downloads/#{file}"
    send_file file_path, :type => 'application/vnd.ms-excel'
  end

  def get_dob_from_age age
    dob_year = Time.now.strftime("%Y").to_i - age
    dob_mon = Time.now.strftime("%b")
    dob_time = dob_mon + " " + dob_year.to_s
    dob = Time.parse(dob_time)
    #return dob.strftime("%d%m%y")
    return dob.strftime("%Y-%m-%d")
  end


end
