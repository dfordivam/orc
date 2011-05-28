class EventsController < ApplicationController
  def new
    @event = Event.new
  end
  
  def create
    @event = Event.new(params[:event])
    if @event.start_date_time > @event.end_date_time
      flash[:notice] = 'Start date can\'t be more than end date !!'  
    else
      if @event.save
         flash[:notice] = 'Done !!'
      else
         flash[:notice] = 'Error !!'
      end
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
