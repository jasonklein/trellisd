class AddLastRakedToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :last_raked, :datetime
  end
end
