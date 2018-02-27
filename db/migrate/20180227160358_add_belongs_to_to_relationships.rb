class AddBelongsToToRelationships < ActiveRecord::Migration[5.1]
  def change
    add_column :relationships, :account_id, :integer
    add_column :relationships, :user_id, :integer
    add_index :relationships, :account_id
    add_index :relationships, :user_id
  end
end
