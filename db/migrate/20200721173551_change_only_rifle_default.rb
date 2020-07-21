class ChangeOnlyRifleDefault < ActiveRecord::Migration[6.0]
  def change
    change_column_default :competitors, :only_rifle, from: nil, to: false
    execute 'update competitors set only_rifle=false where only_rifle is null'
    change_column_null :competitors, :only_rifle, false
  end
end
