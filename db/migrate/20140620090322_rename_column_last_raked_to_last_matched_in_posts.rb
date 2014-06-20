class RenameColumnLastRakedToLastMatchedInPosts < ActiveRecord::Migration
  def change
    rename_column :posts, :last_raked, :last_matched
  end
end
