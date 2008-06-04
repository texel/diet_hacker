require File.dirname(__FILE__) + '/../spec_helper'

module HomeControllerSpecHelper
  
end

describe HomeController do
  include HomeControllerSpecHelper
  integrate_views
  
  describe "index" do
    before(:each) do
      login_user
    end
    
    it "should succeed" do
      get :index
      response.should be_success
    end
    
    it "should assign @data_points" do
      get :index
      assigns(:data_points).should_not be_nil
    end
    
    it "should generate a GChart graph for all datapoints" do
      get :index
      assigns(:chart).class.should == GChart
    end
  end
end