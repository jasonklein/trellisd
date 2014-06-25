class CreateUserFlags < ActiveRecord::Migration
  def change
    create_table :user_flags do |t|
      t.references :flagger
      t.references :flagged

      t.timestamps
    end
    add_index :user_flags, :flagger_id
    add_index :user_flags, :flagged_id
  end
end
