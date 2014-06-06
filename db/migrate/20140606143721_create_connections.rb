class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.references :connecter
      t.references :connectee

      t.timestamps
    end
    add_index :connections, :connecter_id
    add_index :connections, :connectee_id
  end
end
