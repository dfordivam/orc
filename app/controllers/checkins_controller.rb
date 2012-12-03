class CheckinsController < ApplicationController
  before_filter :login_required

  def new
    if (params[:registration_id])
      @registration = Registration.find(params[:registration_id])
      #@visitor = @registration.visitor
      #@building = Building.new
      #@room = Room.new
      @checkin = Checkin.new
      @building_list = Building.where("is_delete = ?", false)
      @rm_list = []
      @flr_list = []
    else
      redirect_to registrations_path
    end
  end

  def edit
    #@registration = Registration.find(params[:registration_id])
    @checkin = Checkin.find(params[:id])
    if @checkin.source_type == "AccompanyVisitor"
      # source id is accompany visitor id
      @acc_v = AccompanyVisitor.find(@checkin.source_id)
      if @acc_v
        @registration = @acc_v.registration
      end
    else
      #if @checkin.source_type = "Registration"
        # source id is registration id
        #@checkin = Checkin.find(params[:source_id])
      @registration = Registration.find(params[:id])
      #@registration = Registration.find(@checkin.source_id)
      #@registration = @reg.registration
      #end
      #@registration = @checkin.registration
    end
    @building_list = Building.where("is_delete = ?", false)
    @rm_list = []
    @flr_list = []
  end

  def index
    @checkins = Checkin.where("is_delete = ?", false).order("created_at DESC").paginate(:page => params[:page], :per_page => 15)
  end

  def show 
    @checkin = Checkin.find(params[:id])
  end

  def print
    @checkin = Checkin.find(params[:id])
    @participant = @checkin.participant
    render :layout => false
  end

  def update
    @checkin = Checkin.find(params[:id])
    #@checkin = Checkin.find_by_id params[:id]
    if @checkin.room && @checkin.room.occupied_beds > 0 
      @checkin.room.update_attribute(:occupied_beds , @checkin.room.occupied_beds - 1)
      @checkin.room.update_attribute(:empty_beds , @checkin.room.total_beds - @checkin.room.occupied_beds)
    end
    @checkin.building_id = params[:checkin][:building_id]
    @checkin.floor_id = params[:fc1][:fc11]
    @checkin.room_id = params[:rc1][:rc11]
    if @checkin.room && @checkin.room.empty_beds > 0 
      @checkin.room.update_attribute(:occupied_beds , @checkin.room.occupied_beds + 1)
      @checkin.room.update_attribute(:empty_beds , @checkin.room.total_beds - @checkin.room.occupied_beds)
    end
    Checkin.transaction do
      if @checkin.save
#        AccompanyVisitor.where(:registration_id => @checkin.source_id).update_all(:is_delete => true)
         Checkin.where("source_id in (?) ", @checkin.source.accompany_visitors.collect(&:id)).update_all(:is_delete => true)
        unless params[:index_total].blank?
          params[:index_total].to_i.times do |index|
            @checkin_accm_user = Checkin.new
            @checkin_accm_user.source_id = params["source_id_#{index}"]
            @checkin_accm_user.source_type = "AccompanyVisitor"
            if @checkin.room && @checkin.room.occupied_beds > 0 
              @checkin.room.update_attribute(:occupied_beds , @checkin.room.occupied_beds - 1)
              @checkin.room.update_attribute(:empty_beds , @checkin.room.total_beds - @checkin.room.occupied_beds)
            end
            @checkin_accm_user.building_id = params["accompany_visitor_building_#{index}"]
            @checkin_accm_user.floor_id = params["accompany_visitor_floor_#{index}"]
            @checkin_accm_user.room_id = params["accompany_visitor_room_#{index}"]
            @checkin_accm_user.is_active = true
            if @checkin.room && @checkin.room.empty_beds > 0 
              @checkin.room.update_attribute(:occupied_beds , @checkin.room.occupied_beds + 1)
              @checkin.room.update_attribute(:empty_beds , @checkin.room.total_beds - @checkin.room.occupied_beds)
            end
            @checkin_accm_user.save
          end
        end
      end
    end
    redirect_to checkins_path
  end

  def create
    #temp_room = Room.where("is_delete = 0 AND building_id = ? AND floor = ? AND room_no = ?", params[:room_id][:building_id],params[:fc1][:fc11],params[:rc1][:rc11]).first

    #if (temp_room.nil? == false)
      #if ! (temp_room.occupied_beds < temp_room.total_beds)
        #flash[:notice] = "#ERROR#This room is full now !! Please select some other room. "
        #redirect_to checkins_path
        #return
      #end
    #else
      #flash[:notice] = "#ERROR#Wrong room specified, please try again. "
      #redirect_to checkins_path
      #return
    #end


    @checkin = Checkin.new
    @checkin.source_id = params[:registration_id]
    @checkin.source_type = "Registration"
    @checkin.building_id = params[:checkin][:building_id]
    @checkin.floor_id = params[:fc1][:fc11]
    @checkin.room_id = params[:rc1][:rc11]
    #@checkin.building_id = temp_room
    #@checkin.floor_id = temp_room
    #@checkin.room_id = temp_room
    if @checkin.room && @checkin.room.empty_beds > 0
      @checkin.room.update_attribute(:occupied_beds , @checkin.room.occupied_beds + 1)
      @checkin.room.update_attribute(:empty_beds , @checkin.room.total_beds - @checkin.room.occupied_beds)
    end
    @checkin.is_active = true
    @checkin.is_delete = false

    Checkin.transaction do
      if @checkin.save
        unless params[:index_total].blank?
	  params[:index_total].to_i.times do |index|
	    @checkin_accm_user = Checkin.new
            @checkin_accm_user.source_id = params["source_id_#{index}"]
            @checkin_accm_user.room_id = params["accompany_visitor_room_#{index}"]
            @checkin_accm_user.building_id = params["accompany_visitor_building_#{index}"]
            @checkin_accm_user.floor_id = params["accompany_visitor_floor_#{index}"]
            if @checkin_accm_user.room && @checkin_accm_user.room.empty_beds > 0 
              @checkin_accm_user.source_type = "AccompanyVisitor"
              @checkin_accm_user.room.update_attribute(:occupied_beds , @checkin.room.occupied_beds + 1)
              @checkin_accm_user.room.update_attribute(:empty_beds , @checkin.room.total_beds - @checkin.room.occupied_beds)
              @checkin_accm_user.is_active = true
              @checkin_accm_user.is_delete = false
	      @checkin_accm_user.save
	    else
	      flash[:notice] = "#ERROR#No more beds available,Please select some other room for the accompanying vistor "              
            end
          end
        end
      end
    end

    if params[:submit_and_print]
      redirect_to print_checkin_path(@checkin)
    else
      redirect_to checkins_path
    end
  end

  def destroy
    @checkin = Checkin.find(params[:id])
    if @checkin.room && @checkin.room.occupied_beds > 0 
      @checkin.room.update_attribute(:occupied_beds , @checkin.room.occupied_beds - 1)
      @checkin.room.update_attribute(:empty_beds , @checkin.room.total_beds - @checkin.room.occupied_beds)
    end
    ## @checkin.destroy
    @checkin.is_delete = true
    #@visitor = @checkin.visitor
    #@visitor.update_attribute(:checkin_date, NIL)

# This is required as regis.checkin should return the correct checkin
    @checkin.source_id = nil
    if @checkin.save 
      flash[:notice] = "Check In Record has been deleted" 
    else
      flash[:notice] = "#ERROR#Error in deleting record " 
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
