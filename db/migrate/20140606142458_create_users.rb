class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.date :birthday
      t.string :image
      t.string :city
      t.string :postcode
      t.text :bio

      t.timestamps
    end
  end
end
