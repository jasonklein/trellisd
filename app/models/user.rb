class User < ActiveRecord::Base
  attr_accessible :bio, :birthday, :city, :email, :first_name, :image, :last_name, :postcode

  has_many :posts

  has_many :made_connections, class_name: "Connection", foreign_key: "connecter_id"
  has_many :received_connections, class_name: "Connection", foreign_key: "connectee_id"

  def connections
    self.made_connections + self.received_connections
  end

  def posts_of_connections
    connection_ids = []
    self.made_connections.each do |connection|
      connection_ids << connection.connectee_id
    end
    self.received_connections.each do |connection|
      connection_ids << connection.connecter_id
    end
    connection_ids = connection_ids.uniq
    Post.where(user_id: connection_ids)
  end

end
