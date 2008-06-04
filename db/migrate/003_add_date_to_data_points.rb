class AddDateToDataPoints < ActiveRecord::Migration
  def self.up
    add_column :data_points, :date, :date
  end

  def self.down
    remove_column :data_points, :date
  end
end
