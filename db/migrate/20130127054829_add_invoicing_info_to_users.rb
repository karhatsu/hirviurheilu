class AddInvoicingInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :invoicing_info, :text
  end
end
