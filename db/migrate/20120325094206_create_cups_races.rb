class CreateCupsRaces < ActiveRecord::Migration
  def change
    create_table :cups_races do |t|
      t.references :cup, :null => false
      t.references :race, :null => false
    end
  end
end
