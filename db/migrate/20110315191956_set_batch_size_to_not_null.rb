class SetBatchSizeToNotNull < ActiveRecord::Migration
  def self.up
    Race.all.each do |race|
      unless race.batch_size
        race.update_attribute(:batch_size, 0)
      end
    end
    change_column :races, :batch_size, :integer, :default => 0, :null => false
  end

  def self.down
    change_column :races, :batch_size, :integer, :null => true
  end
end
