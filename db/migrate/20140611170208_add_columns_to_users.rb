class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :birthday, :date
    add_column :users, :image, :string
    add_column :users, :city, :string
    add_column :users, :postcode, :string
    add_column :users, :bio, :text
    add_column :users, :role, :string
  end
end
