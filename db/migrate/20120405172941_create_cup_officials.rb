class CreateCupOfficials < ActiveRecord::Migration
  def change
    create_table :cup_officials, :id => false do |t|
      t.references :cup, :null => false
      t.references :user, :null => false
    end
  end
end
