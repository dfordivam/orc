require 'spec_helper'

describe Visitor do

  before(:each) do
    @attr = { :name => "example" }
  end

  it "should create a new instance given valid attributes" do
    Visitor.create!(@attr)
  end

  it "should require a valid name" do
    vis = Visitor.new(@attr.merge(:name => ""))
    vis.should_not be_valid
  end
end
