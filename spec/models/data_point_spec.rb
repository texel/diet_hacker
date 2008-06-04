require File.dirname(__FILE__) + '/../spec_helper'

module DataPointSpecHelper
  def self.included(target)
    target.fixtures :users
  end
  
  def new_data_point(options={})
    default_options = {:weight => 155, :date => Date.today}
    @data_point = DataPoint.new(default_options.merge(options))
  end
end

describe DataPoint do
  include DataPointSpecHelper
  
  describe "validations" do
    it "should have a weight" do
      new_data_point.weight = nil
      @data_point.valid?
      @data_point.errors.on(:weight).should_not be_nil
    end
    
    it "should have a date" do
      new_data_point.date = nil
      @data_point.valid?
      @data_point.errors.on(:date).should_not be_nil
    end
    
    it "should not allow two data points for the same user and date" do
      @user = users(:quentin)
      new_data_point({:user => @user})
      @data_point.save!
      new_data_point({:user => @user})
      @data_point.valid?
      @data_point.errors.on(:date).should_not be_nil
    end
  end
end