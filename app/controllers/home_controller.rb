class HomeController < ApplicationController
  before_filter :login_required
  
  def index
    @data_points = @current_user.data_points.reverse
    @chart = @current_user.prepare_chart
  end
end
