class AddStartTimeToRaces < ActiveRecord::Migration
  def change
    add_column :races, :start_time, :time, null: false, default: '00:00'
  end
end
