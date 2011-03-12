class CreateRelayCorrectEstimates < ActiveRecord::Migration
  def self.up
    create_table :relay_correct_estimates do |t|
      t.references :relay, :null => false
      t.integer :distance, :null => false

      t.timestamps
    end

    add_index :relay_correct_estimates, :relay_id
  end

  def self.down
    drop_table :relay_correct_estimates
  end
end
