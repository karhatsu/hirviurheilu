class CreateCupSeries < ActiveRecord::Migration
  def change
    create_table :cup_series do |t|
      t.references :cup
      t.string :name, :null => false
      t.string :series_names
      
      t.timestamps
    end
  end
end
