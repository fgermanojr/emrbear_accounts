class AddRolesOperationsJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_table :permitteds, id: false do |t|
      t.integer :role_id
      t.integer :operation_id
      t.string :type
    end
    add_index :permitteds, :role_id
    add_index :permitteds, :operation_id
  end
end
