class AddIndexForAcctNameOnAccountss < ActiveRecord::Migration[5.1]
  def change
    add_index :accounts, :name
  end
end
