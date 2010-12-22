class AddCorrectEstimatesToCompetitors < ActiveRecord::Migration
  def self.up
    add_column :competitors, :correct_estimate1, :integer
    add_column :competitors, :correct_estimate2, :integer
  end

  def self.down
    remove_column :competitors, :correct_estimate1
    remove_column :competitors, :correct_estimate2
  end
end
