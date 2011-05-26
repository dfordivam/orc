class CheckinsController < ApplicationController
  def new
    @checkin = Checkin.new
    @event_list = ["dummy_event", "dummy_event2"]
  end

  def index
  end
end
