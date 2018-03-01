class RenameTypeToRelationshipTypeInRelationships < ActiveRecord::Migration[5.1]
  def change
    rename_column :relationships, :type, :relationship_type
  end
end
