class EventsController < ApplicationController
  def new
    @event = Event.new
  end
  
  def create
    @event = Event.new(params[:event])
    if @event.start_date_time > @event.end_date_time
      flash[:notice] = 'Start date can\'t be more than end date !!'  
      redirect_to new_event_path
    else
      if @event.save
         flash[:notice] = 'Done !!'
         redirect_to events_path
      else
         flash[:notice] = 'Error !!'
         redirect_to new_event_path
      end
    end
  end

  def update
    @event = Event.new(params[:event])
    if @event.save
       flash[:notice] = 'Done !!'
    else
       flash[:notice] = 'Error !!'
    end
    redirect_to events_path
  end

  def edit
    @event = Event.find(param[:id])
  end

  def show
    @event = Event.find(param[:id])
  end

  def destroy 
    @event = Event.find(param[:id])
    @event.destroy
    redirect_to events_path
  end    

  def index
    @events = Event.find(:all)
  end
end
