class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :title, limit: 255, null: false
      t.integer :year, null: false
      t.references :author, null: false, foreign_key: true

      t.timestamps
    end
  end
end
