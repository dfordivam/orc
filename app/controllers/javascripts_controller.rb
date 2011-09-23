class JavascriptsController < ApplicationController
  before_filter :login_required
  def checkin
    @full_room_list_checkin = Room.find(:all, :conditions => ["is_delete = 0 and empty_beds > 0"], :order => "floor, room_no")
  end
  def visitor
    @full_room_list = Room.find(:all, :conditions => ["is_delete = 0 and empty_beds > 0"] ,:order => "floor, room_no")
  end
end
