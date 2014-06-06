class CreateKeywordsPosts < ActiveRecord::Migration
  def change
    create_table :keywords_posts do |t|
      t.references :keyword
      t.references :post

      t.timestamps
    end
    add_index :keywords_posts, :keyword_id
    add_index :keywords_posts, :post_id
  end
end
