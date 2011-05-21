class VisitorsController < ApplicationController
  def new
    @visitor = Visitor.new
    @coll = ["BK" , "Non BK"] #_visitor_types
  end

  def create
    @visitor = Visitor.new(params[:visitor])
    if @visitor.save
      flash[:notice] = "New visitor successfully created"
      redirect_to visitors_path
    else
      render new_visitor_path
    end
    
  end

  def list
    @visitors = Visitor.find(:all)

  end
end
