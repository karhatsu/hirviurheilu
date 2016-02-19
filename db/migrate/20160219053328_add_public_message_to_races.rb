class AddPublicMessageToRaces < ActiveRecord::Migration
  def change
    add_column :races, :public_message, :text
  end
end
