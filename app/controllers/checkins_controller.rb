class CheckinsController < ApplicationController
  before_filter :login_required

  def new
    if (params[:registration_id])
      @registration = Registration.find(params[:registration_id])
      @checkin = Checkin.new
      @building_list = Building.where("is_delete = ?", 0)
      @rm_list = []
      @flr_list = []
    else
      redirect_to registrations_path
    end
  end

  def edit
    @registration = Registration.find(params[:id])
    @checkin = @registration.checkin
    @building_list = Building.where("is_delete = ?", 0)
    @rm_list = []
    @flr_list = []
  end

  def index
    @checkins = Checkin.where("is_delete = ?", false).paginate(:page => params[:page], :per_page => 15)
  end

  def show 
    @checkin = Checkin.find(params[:id])
  end

  def update
    @checkin = Checkin.find_by_id params[:id]
    @checkin.building_id = params[:checkin][:building_id]
    @checkin.floor_id = params[:fc1][:fc11]
    @checkin.room_id = params[:rc1][:rc11]
    Checkin.transaction do
      if @checkin.save
#        AccompanyVisitor.where(:registration_id => @checkin.source_id).update_all(:is_delete => true)
         Checkin.where("source_id in (?) ", @checkin.source.accompany_visitors.collect(&:id)).update_all(:is_delete => true)
        unless params[:index_total].blank?
          params[:index_total].to_i.times do |index|
            @checkin_accm_user = Checkin.new
            @checkin_accm_user.source_id = params["source_id_#{index}"]
            @checkin_accm_user.source_type = "AccompanyVisitor"
            @checkin_accm_user.building_id = params["accompany_visitor_building_#{index}"]
            @checkin_accm_user.floor_id = params["accompany_visitor_floor_#{index}"]
            @checkin_accm_user.room_id = params["accompany_visitor_room_#{index}"]
            @checkin_accm_user.is_active = true
            @checkin_accm_user.save
          end
        end
      end
    end
    redirect_to checkins_path
  end

  def create
    @checkin = Checkin.new
    @checkin.source_id = params[:registration_id]
    @checkin.source_type = "Registration"
    @checkin.building_id = params[:checkin][:building_id]
    @checkin.floor_id = params[:fc1][:fc11]
    @checkin.room_id = params[:rc1][:rc11]
    @checkin.is_active = true
    Checkin.transaction do
      if @checkin.save
        unless params[:index_total].blank?
          params[:index_total].to_i.times do |index|
            @checkin_accm_user = Checkin.new
            @checkin_accm_user.source_id = params["source_id_#{index}"]
            @checkin_accm_user.source_type = "AccompanyVisitor"
            @checkin_accm_user.building_id = params["accompany_visitor_building_#{index}"]
            @checkin_accm_user.floor_id = params["accompany_visitor_floor_#{index}"]
            @checkin_accm_user.room_id = params["accompany_visitor_room_#{index}"]
            @checkin_accm_user.is_active = true
            @checkin_accm_user.save
          end
        end
      end
    end
    redirect_to checkins_path
  end

  def destroy
    @checkin = Checkin.find(params[:id])
    if @checkin.room && @checkin.room.occupied_beds > 0 
      @checkin.room.update_attribute(:occupied_beds , @checkin.room.occupied_beds - 1)
      @checkin.room.update_attribute(:empty_beds , @checkin.room.total_beds - @checkin.room.occupied_beds)
    end
    ## @checkin.destroy
    @checkin.is_delete = 1
    @visitor = @checkin.visitor
    @visitor.update_attribute(:checkin_date, NIL)

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
