class ChangeBatchIntervalSecondsInRaces < ActiveRecord::Migration
  def self.up
    Race.all.each do |race|
      unless race.batch_interval_seconds
        race.update_attribute(:batch_interval_seconds, 180)
      end
    end
    change_column :races, :batch_interval_seconds, :integer, :null => false, :default => 180
  end

  def self.down
    change_column :races, :batch_interval_seconds, :integer, :null => true, :default => nil
  end
end
