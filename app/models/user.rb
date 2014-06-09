class User < ActiveRecord::Base
  attr_accessible :bio, :birthday, :city, :email, :first_name, :image, :last_name, :postcode

  has_many :posts

  has_many :made_connections, class_name: "Connection", foreign_key: "connecter_id"
  has_many :received_connections, class_name: "Connection", foreign_key: "connectee_id"

  def connections
    made_connection_ids = Connection.where(connecter_id: self.id)
    received_connection_ids = Connection.where(connectee_id: self.id)
    total_connections = made_connection_ids + received_connection_ids
    Connection.where(id: total_connections)
  end
end
