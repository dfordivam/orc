class UserSessionsController < ApplicationController
  before_filter :login_required, :only => :logout
  def new
    @user_session = UserSession.new
    render :layout => "login"
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Successfully logged in."
      redirect_to new_visitor_path
    else
      render :action => 'new'
    end
  end

  def logout
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "Successfully logged out."
    redirect_to root_url
  end    

end
