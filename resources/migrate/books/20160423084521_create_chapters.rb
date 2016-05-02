class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.references :book, index: true, foreign_key: true
      t.string :title
      t.text :body
      t.integer :page_count

      t.timestamps null: false
    end
  end
end
