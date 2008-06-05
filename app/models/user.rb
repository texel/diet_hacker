require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  
  has_many :data_points

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login,    :case_sensitive => false
  validates_format_of       :login,    :with => RE_LOGIN_OK, :message => MSG_LOGIN_BAD

  validates_format_of       :name,     :with => RE_NAME_OK,  :message => MSG_NAME_BAD, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_format_of       :email,    :with => RE_EMAIL_OK, :message => MSG_EMAIL_BAD

  

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation



  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  def eight_day_averages
    dp = self.data_points
    averages = []
    7.upto(dp.length - 1) do |index|
      last_eight = dp[(index - 7)..index]
      average_dp = DataPoint.new(:weight => DataPoint.average_weight(last_eight), :date => dp[index].date)
      averages << average_dp
    end
    averages
  end
  
  def prepare_chart
    data_points = self.data_points
    unless data_points.length <= 3
      chart = GChart.xyline do |chart|
        chart.title = "Weight over time"
        all_data = DataPoint.for_xy_line(data_points)
        eight_day = DataPoint.for_xy_line(self.eight_day_averages) unless data_points.length < 8
        chart_data = []
        unless all_data.blank?
          [DataPoint.scale(all_data[0]), DataPoint.scale(all_data[1])].each do |v|
            chart_data << v
          end
        end
        unless eight_day.blank?
          [DataPoint.scale(eight_day[0], all_data[0].min), DataPoint.scale(eight_day[1], all_data[1].min)].each do |v|
            chart_data << v
          end
        end
        chart.data = chart_data
        chart.colors = [:red, :blue]
        legends = ["Daily"] ; legends << "8 Day Average" if eight_day
        chart.legend = legends
        #chart.axis(:left) { |a| a.range = 0..250 }
        #chart.axis(:bottom) { |a| a.range = 0..1000}
        chart.size = "500x400"
        chm_args = chart.data[0].map {|index| "s,ff9900,0,#{index},5.0"}.join("|")
        chart.extras = {:chm => chm_args}
      end
    end
  end

  protected
    


end
