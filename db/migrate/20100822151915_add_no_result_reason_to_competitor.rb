class AddNoResultReasonToCompetitor < ActiveRecord::Migration
  def self.up
    add_column :competitors, :no_result_reason, :string
  end

  def self.down
    remove_column :competitors, :no_result_reason
  end
end
