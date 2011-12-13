class Registration < ActiveRecord::Base
  before_filter :login_required

  def index
      @registrations = Registration.find(:all, :conditions => ["is_delete = ?", false], :order => "id").paginate(:page => params[:page], :per_page => 15)
  end

  def show
      @registration = Registration.find(params[:id], :conditions => ["is_delete = ?", 0])
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
