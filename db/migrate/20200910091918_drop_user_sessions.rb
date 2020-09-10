class DropUserSessions < ActiveRecord::Migration[6.0]
  def up
    drop_table :user_sessions
  end

  def down
    create_table :user_sessions do |t|
      t.string :session_id
      t.text :data

      t.timestamps
    end

    add_index :user_sessions, :session_id
    add_index :user_sessions, :updated_at
  end
end
