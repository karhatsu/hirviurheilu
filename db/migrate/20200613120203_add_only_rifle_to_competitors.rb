class AddOnlyRifleToCompetitors < ActiveRecord::Migration[6.0]
  def change
    add_column :competitors, :only_rifle, :boolean
  end
end
