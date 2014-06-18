class RemoveColumnsFromKeywordsPosts < ActiveRecord::Migration
  def up
    remove_column :keywords_posts, :created_at
    remove_column :keywords_posts, :updated_at
  end

  def down
    add_column :keywords_posts, :updated_at, :string
    add_column :keywords_posts, :created_at, :string
  end
end
