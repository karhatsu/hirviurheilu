class AddClubNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :club_name, :string
  end
end
