class ReportsController < ApplicationController
  before_filter :login_required
  def index
    @search_value  = params[:search_value]
    if @search_value
      @visitors = Visitor.search @search_value, :conditions => { :is_delete => '0' }
    else 
      @visitors = Visitor.where(:is_delete => false).order(:name,:address).paginate(:page => params[:page], :per_page => 15)
    end
  end
end
