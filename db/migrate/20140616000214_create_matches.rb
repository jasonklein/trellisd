class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.references :post
      t.references :matching
      t.integer :keyword_coverage

      t.timestamps
    end
    add_index :matches, :post_id
    add_index :matches, :matching_id
  end
end
