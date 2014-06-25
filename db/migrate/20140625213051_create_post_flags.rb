class CreatePostFlags < ActiveRecord::Migration
  def change
    create_table :post_flags do |t|
      t.references :flagger
      t.references :post

      t.timestamps
    end
    add_index :post_flags, :flagger_id
    add_index :post_flags, :post_id
  end
end
