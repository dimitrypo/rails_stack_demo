class CreateArticles < ActiveRecord::Migration[7.2]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.boolean :published, default: false, null: false
      t.string :slug
      t.datetime :published_at

      t.timestamps
    end
    add_index :articles, :slug, unique: true
    add_index :articles, :published
    add_index :articles, :published_at
  end
end
