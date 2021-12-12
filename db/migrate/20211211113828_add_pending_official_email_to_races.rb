class AddPendingOfficialEmailToRaces < ActiveRecord::Migration[6.1]
  def change
    add_column :races, :pending_official_email, :string
  end
end
