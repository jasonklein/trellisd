class User < ActiveRecord::Base
  attr_accessible :bio, :birthday, :city, :email, :first_name, :image, :last_name, :postcode

  has_many :posts

  has_many :made_connections, class_name: "Connection", foreign_key: "connecter_id"
  has_many :received_connections, class_name: "Connection", foreign_key: "connectee_id"

  def connections
    self.made_connections + self.received_connections
  end

  # Fill array with ids of users to whom a particular user
  # is connected, returning that array

  def ids_of_connections
    connection_ids = []
    self.made_connections.each do |connection|
      connection_ids << connection.connectee_id
    end
    self.received_connections.each do |connection|
      connection_ids << connection.connecter_id
    end
    connection_ids = connection_ids.uniq
    connection_ids
  end

  def posts_of_connections
    Post.where(user_id: self.ids_of_connections)
  end

  def posts_of_connections_for_a_category(category_id)
    Post.where(user_id: self.ids_of_connections, category_id: category_id)
  end
end
