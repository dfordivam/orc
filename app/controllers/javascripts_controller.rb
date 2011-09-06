class JavascriptsController < ApplicationController
  before_filter :login_required
  def checkin
    @room_list = Room.where("empty_beds > 0")
  end
  def visitor
  end
end
