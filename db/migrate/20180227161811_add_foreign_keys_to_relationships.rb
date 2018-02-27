class AddForeignKeysToRelationships < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key :relationships, :users
    add_foreign_key :relationships, :accounts
  end
end
