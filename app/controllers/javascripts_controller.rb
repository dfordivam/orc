class JavascriptsController < ApplicationController
  def checkin
    @room_list = Room.find(:all)
  end
end
