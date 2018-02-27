class RenameAuthyIdToTokenInUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :authy_id
    add_column :users, :token, :string
  end
end
