class AddOperationsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :operations do |t|
      t.string :op_controller
      t.string :op_action
      t.timestamps
    end
    add_index :operations, [:op_controller, :op_action]
  end
end
