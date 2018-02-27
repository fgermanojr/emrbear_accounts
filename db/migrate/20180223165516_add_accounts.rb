class AddAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.string :name, presence: true
      t.timestamps
    end
  end
end
