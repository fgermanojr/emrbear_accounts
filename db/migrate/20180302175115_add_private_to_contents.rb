class AddPrivateToContents < ActiveRecord::Migration[5.1]
  def change
    add_column :contents, :private, :boolean
  end
end
