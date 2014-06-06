class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :category
      t.string :title
      t.text :content
      t.references :user
      t.date :expiration
      t.string :range
      t.boolean :alert

      t.timestamps
    end
  end
end
