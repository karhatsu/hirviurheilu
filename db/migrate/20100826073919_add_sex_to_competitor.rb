class AddSexToCompetitor < ActiveRecord::Migration
  def self.up
    add_column :competitors, :sex, :string, :limit => 1, :null => false, :default => 'M'
  end

  def self.down
    remove_column :competitors, :sex
  end
end
