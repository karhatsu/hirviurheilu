class AddUseQualificationRoundResultToCups < ActiveRecord::Migration[7.0]
  def change
    add_column :cups, :use_qualification_round_result, :boolean, null: false, default: false
  end
end
