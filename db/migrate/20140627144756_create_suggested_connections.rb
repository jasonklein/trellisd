class CreateSuggestedConnections < ActiveRecord::Migration
  def change
    create_table :suggested_connections do |t|
      t.references :user
      t.references :connectee

      t.timestamps
    end
    add_index :suggested_connections, :user_id
    add_index :suggested_connections, :connectee_id
  end
end
