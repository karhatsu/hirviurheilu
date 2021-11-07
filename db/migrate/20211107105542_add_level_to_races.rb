class AddLevelToRaces < ActiveRecord::Migration[6.1]
  def change
    add_column :races, :level, :integer, null: false, default: 0
  end
end
