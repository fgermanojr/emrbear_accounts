class AddBusinessActionToOperations < ActiveRecord::Migration[5.1]
  def change
    add_column :operations, :business_action, :string
  end
end
