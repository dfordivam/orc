require 'authentication'
class ApplicationController < ActionController::Base
  include Authentication
  helper :all
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access denied."
#    redirect_to root_url
    redirect_to new_visitor_path
  end

#  helper_method :current_user
  
#  private
#  def current_user_session
#    return @current_user_session if defined?(@current_user_session)
#    @current_user_session = UserSession.find
#  end
#
#  def current_user
#    @current_user = current_user_session && current_user_session.record
#  end
end
