class RenameColumnTypeInPostsToDirectionality < ActiveRecord::Migration
  def change
    rename_column :posts, :type, :directionality
  end
end
