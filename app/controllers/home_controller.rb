class HomeController < ApplicationController
  before_filter :login_required
  def index
    
  end
  def index_list
    render :layout => "home_list"
  end
end
