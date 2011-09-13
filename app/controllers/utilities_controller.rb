class UtilitiesController < ApplicationController
  require 'mime/types'
  require 'spreadsheet'
  
  def index
  end
  
  def user_list
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
  
  def usr_load
    flash[:notice] = nil
    unique_file_name = params[:id]
    directory = "#{RAILS_ROOT}/public/uploads/user_list"
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
            flash[:notice] = "Fatal Error in USERS_ROLES!! Contact Admin !! Reference: #{unique_file_name}"
          end
        else
          flash[:notice] = "Fatal Error in USERS!! Contact Admin !! Reference: #{unique_file_name}"
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
      flash[:notice] = " Please choose the file first and then upload !!"
      render 'index'
    end
    return
  end

  private

  def check_users_for_errors(users)
    email_list = User.find_by_sql("select distinct trim(email) email from users")
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
        if ! row.nil? then
          record_counter += 1
          roleID = row[3] == "admin" ? 1 : (row[3] == "moderator" ? 2 : 3)
          @users.insert(-1,{:username=>row[0],:email=>row[1],:role_id=>roleID,:password=>row[2],:role=>row[3],:isbad=>false,:comment=>"All Valid Fields"})
        end
      end
      check_users_for_errors(@users)
    else
      flash[:notice] = "Missing Header Record !. Please use the template file to upload the users list !!"
    end
    return @users
  end
  
  def handleUploadUserList(file)
    if ! file.nil?
      if (file.content_type && file.content_type.chomp == "application/vnd.ms-excel")
        @unique_file_name = save_file(file,"user_list")
        @full_file_name = "#{RAILS_ROOT}/public/uploads/user_list/#{ @unique_file_name}"
        @users = extract_users_from_excel(@full_file_name)
        if flash[:notice].nil?
          render 'user_list'
        else
          render 'index'
        end
      else
        flash[:notice] = 'File type error. Please upload MS-Excel File !!'
        render 'index'
      end
    else
      flash[:notice] = file.original_filename||" Please choose the file first and then upload !!"
      render 'index'
    end
  end

  def handleUploadBuildingList(file)
    flash[:notice] = "Yet to develop this utility... Only #1 utility is done right now"
    render 'index'
  end

  def handleUploadEventList(file)
    flash[:notice] = "Yet to develop this utility... Only #1 utility is done right now"
    render 'index'
  end

  def save_file(file,folder)
    directory = "#{RAILS_ROOT}/public/uploads/#{folder}"
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
