class HomeController < ApplicationController
  before_filter :login_required
  
  def index
    @data_points = @current_user.data_points.reverse
    @chart = GChart.xyline do |chart|
      chart.title = "Weight over time"
      all_data = DataPoint.for_xy_line(@current_user.data_points)
      eight_day = DataPoint.for_xy_line(@current_user.eight_day_averages)
      chart.data = [DataPoint.scale(all_data[0]), DataPoint.scale(all_data[1]), DataPoint.scale(eight_day[0], all_data[0].min), DataPoint.scale(eight_day[1], all_data[1].min)]
      chart.colors = :red, :blue
      chart.legend = "Daily", "8 Day Average"
      #chart.axis(:left) { |a| a.range = 0..250 }
      #chart.axis(:bottom) { |a| a.range = 0..1000}
      chart.size = "500x400"
      chm_args = chart.data[0].map {|index| "s,ff9900,0,#{index},5.0"}.join("|")
      chart.extras = {:chm => chm_args}
    end
  end
end
