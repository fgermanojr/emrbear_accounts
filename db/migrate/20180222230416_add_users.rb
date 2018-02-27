class AddUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name, presence: true
      t.string :email, presence: true
      t.string :password_digest
      t.integer :authy_id
      t.timestamps
    end
  end
end
