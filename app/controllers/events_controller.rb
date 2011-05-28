class EventsController < ApplicationController
  def new
    @event = Event.new
  end
  
  def create
    @event = Event.new(params[:event])
    if @event.save
       flash[:notice] = 'Done !!'
    else
       flash[:notice] = 'Error !!'
    end
    render :action => 'new'
  end

  def update
    @event = Event.new(params[:event])
    if @event.save
       flash[:notice] = 'Done !!'
    else
       flash[:notice] = 'Error !!'
    end
    render :action => 'new'
  end
  def index
    @events = Event.find(:all)
  end
end
