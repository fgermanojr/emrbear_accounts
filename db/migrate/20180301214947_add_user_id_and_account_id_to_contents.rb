class AddUserIdAndAccountIdToContents < ActiveRecord::Migration[5.1]
  def change
    add_column :contents, :user_id, :integer
    add_column :contents, :account_id, :integer
    add_index :contents, :user_id
    add_index :contents, :account_id
  end
end
