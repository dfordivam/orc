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
        temp_room[:building_id] = temp_build_id
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
      if users[us][:username].nil? || users[us][:email].nil? || users[us][:role_id].nil? || users[us][:password].nil? || users[us][:role].nil?
        users[us][:isbad] = true
        users[us][:comment] = "No Fields Should Be Blank !!"
      end
      if ! email_list.detect{|em| em.email == users[us][:email]}.nil?
        users[us][:isbad] = true
        users[us][:comment] = "Email already exists !!"
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
      if (file.content_type && file.content_type.chomp == "application/vnd.ms-excel")
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

  def handleUploadBuildingList(file)
    if ! file.nil?
      if (file.content_type && file.content_type.chomp == "application/vnd.ms-excel")
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
    flash[:notice] = "#ERROR#Yet to develop this utility... Only #1 & #2 utilities are done right now"
    render 'index'
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

end
