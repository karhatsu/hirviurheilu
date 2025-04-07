class AddDescriptionToHeats < ActiveRecord::Migration[8.0]
  def change
    add_column :heats, :description, :string
  end
end
