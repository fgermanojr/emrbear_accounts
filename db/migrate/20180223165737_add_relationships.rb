class AddRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.string :type, presence: true
      t.timestamps
    end
  end
end
