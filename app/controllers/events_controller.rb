class EventsController < ApplicationController
  before_filter :login_required
  load_and_authorize_resource
  
  def new
    @event = Event.new
  end
  
  def create
    @event = Event.new(params[:event])
    if !@event.start_date_time.nil? && !@event.end_date_time.nil? && @event.start_date_time > @event.end_date_time
      flash[:notice] = '#ERROR#Start date can\'t be more than end date'  
      render 'new'
    else
      if @event.save
         flash[:notice] = 'Done '
         redirect_to events_path
      else
         flash[:notice] = nil
         render 'new'
      end
    end
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      redirect_to events_path
    else
      render 'edit'
    end
  end

  def edit
    @event = Event.find(params[:id])
    @event.start_date_time=@event.start_date_time.strftime("%d %B %Y")
    @event.end_date_time=@event.end_date_time.strftime("%d %B %Y")
  end

  def show
    @event = Event.find(params[:id])
  end

  def destroy 
    @event = Event.find(params[:id])
    ## @event.destroy
    @event.is_delete = 1
    if @event.save 
      temp_registration = Registration.find(:all,:conditions => ["event_id = ?", @event.id])
      temp_checkin = Checkin.find(:all,:conditions => ["event_id = ?", @event.id])
      for t_r in temp_registration
        t_r.update_attribute(:is_delete,1)
      end
      for t_c in temp_checkin
        t_c.update_attribute(:is_delete,1)
      end
      flash[:notice] = "Event #{@event.name} has been deleted" 
    else
      flash[:notice] = "#ERROR#Error in deleting event #{@event.name} " 
    end
    redirect_to events_path
  end    

  def index
    @events = Event.where(:is_delete => false).order("start_date_time DESC").paginate(:page => params[:page], :per_page => 15)
  end

  def participants
    @participants = Registration.where(:event_id => params[:id], :is_delete => false).paginate(:page => params[:page], :per_page => 15)
#    @participants = [1,2]
  end
end
