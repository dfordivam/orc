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

  def index
    @visitors = Visitor.find(:all)
  end

  def show
    @visitor = Visitor.find(params[:id])
  end

  def edit
    @visitor = Visitor.find(params[:id])
  end

  def destroy
    @visitor = Visitor.find(params[:id])
    @visitor.destroy
    redirect_to visitors_path
  end

  def update
  end
end
