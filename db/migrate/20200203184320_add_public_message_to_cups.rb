class AddPublicMessageToCups < ActiveRecord::Migration[6.0]
  def change
    add_column :cups, :public_message, :text
  end
end
