class FixIndexesOnRelationships < ActiveRecord::Migration[5.1]
  def change
    remove_index :contents, :user_id
    remove_index :contents, :account_id
    add_index :contents, [:user_id, :account_id]
  end
end
