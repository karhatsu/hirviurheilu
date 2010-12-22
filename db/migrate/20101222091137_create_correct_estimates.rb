class CreateCorrectEstimates < ActiveRecord::Migration
  def self.up
    create_table :correct_estimates do |t|
      t.references :race, :null => false
      t.integer :min_number, :null => false
      t.integer :max_number
      t.integer :distance1, :null => false
      t.integer :distance2, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :correct_estimates
  end
end
