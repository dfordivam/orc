class VisitorController < ApplicationController
  def new
    @visitor = Visitor.new
    @coll = ["BK" , "Non BK"] #_visitor_types
  end
end
