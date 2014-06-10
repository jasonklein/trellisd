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

  def ids_of_primary_connections
    connection_ids = []
    self.made_connections.each do |connection|
      connection_ids << connection.connectee_id
    end
    self.received_connections.each do |connection|
      connection_ids << connection.connecter_id
    end
    connection_ids.uniq
  end

  # Fill array with ids of users to whom a particular user
  # is secondarily connected/connected by another user
  # returning that array

   def ids_of_secondary_connections
    primary_connection_ids = self.ids_of_primary_connections
    secondary_connections_ids = []
    primary_connection_ids.each do |connection_id|
      connection = User.find(connection_id)
      connection_ids = connection.ids_of_primary_connections
      secondary_connections_ids += connection_ids
    end
    secondary_connections_ids -= primary_connection_ids
    secondary_connections_ids.uniq
  end

  def ids_of_tertiary_connections
    primary_connection_ids = self.ids_of_primary_connections
    secondary_connections_ids = self.ids_of_secondary_connections
  end

  # TODO: Determine which method to call to get posts by user_id

  # def posts_of_connections
  #   Post.where(user_id: self.ids_of_connections)
  # end

  # def posts_of_connections_for_a_category(category_id)
  #   Post.where(user_id: self.ids_of_connections, category_id: category_id)
  # end
end
