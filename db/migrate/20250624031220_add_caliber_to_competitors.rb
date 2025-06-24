class AddCaliberToCompetitors < ActiveRecord::Migration[8.0]
  def change
    add_column :competitors, :caliber, :string
  end
end
