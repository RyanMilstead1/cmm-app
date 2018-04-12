class CreateWikis < ActiveRecord::Migration[5.2]
  def change
    create_table :wikis do |t|
      t.string :title
      t.text :body
      t.string :slug, unique: true
      t.boolean :private, default: false
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
