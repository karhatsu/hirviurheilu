class CreateCups < ActiveRecord::Migration
  def change
    create_table :cups do |t|
      t.string :name, :null => false
      t.integer :top_competitions, :null => false, :default => 2

      t.timestamps
    end
  end
end
