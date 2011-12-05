class UserSessionsController < ApplicationController
  before_filter :login_required, :only => :logout
  def new
    @user_session = UserSession.new
    render :layout => "login"
  end

  def create
    @user_session = UserSession.new(params[:user_session])
     
      if @user_session.save
      flash[:notice] = "Welcome  #{current_user.username.humanize}"
      redirect_to new_visitor_path
      else
      flash[:notice] = "#ERROR#Incorrect Login Details. Please Enter Valid Username and Password"
      redirect_to new_user_session_path
      end 
  end


  def logout
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "Successfully logged out."
    redirect_to root_url
  end    

end
