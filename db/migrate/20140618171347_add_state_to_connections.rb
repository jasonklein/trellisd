class AddStateToConnections < ActiveRecord::Migration
  def change
    add_column :connections, :state, :string, default: :pending
  end
end
