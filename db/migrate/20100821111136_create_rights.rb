class CreateRights < ActiveRecord::Migration
  def self.up
    create_table :rights, :id => false do |t|
      t.references :user, :null => false
      t.references :role, :null => false

      t.timestamps
    end

    add_index :rights, :user_id
  end

  def self.down
    drop_table :rights
  end
end
