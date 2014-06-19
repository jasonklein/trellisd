class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :sender
      t.references :recipient
      t.text :content
      t.boolean :sender_readability, default: true
      t.boolean :recipient_readability, default: true
      t.boolean :viewed, default: false

      t.timestamps
    end
    add_index :messages, :sender_id
    add_index :messages, :recipient_id
  end
end
