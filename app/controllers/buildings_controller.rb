class BuildingsController < ApplicationController
  def new
    @building = Building.new
  end
end
