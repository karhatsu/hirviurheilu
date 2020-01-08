class CreateBatches < ActiveRecord::Migration[6.0]
  def change
    create_table :batches do |t|
      t.references :race, foreign_key: true
      t.integer :number, null: false
      t.integer :track, null: false
      t.datetime :time, null: false

      t.timestamps
    end
  end
end
