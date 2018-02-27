class AddContents < ActiveRecord::Migration[5.1]
  def change
    create_table :contents do |t|
      t.string :content_text, presence: true
      t.timestamps
    end
  end
end
