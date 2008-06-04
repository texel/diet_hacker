class DataPoint < ActiveRecord::Base
  belongs_to :user
  named_scope :for_date, lambda {|date| {:conditions => {:date => date}}}
  
  validates_presence_of :weight, :date
  validates_uniqueness_of :date, :scope => :user_id
  
  # Calculate the average weight of n data_points
  def self.average_weight(data_points)
    sum = data_points.inject(0) {|m, dp| m += dp.weight}
    average = sum / data_points.length
  end
  
  def self.for_xy_line(data_points)
    weights = data_points.map {|dp| dp.weight}
    dates = data_points.map {|dp| (dp.date - 2.months.ago.to_date).to_i}
    return dates, weights
  end
  
  def self.scale(array, min=nil)
    min ||= array.min
    array.map {|value| value - min}
  end
end
