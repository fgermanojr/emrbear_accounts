class AddRelationshipIdToContents < ActiveRecord::Migration[5.1]
  def change
    add_column :contents, :relationship_id, :integer
    add_index :contents, :relationship_id
  end
end
