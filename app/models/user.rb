class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :birthday, :image, :city, :postcode, :bio, :role

  has_many :posts

  has_many :made_connections, class_name: "Connection", foreign_key: "connecter_id"
  has_many :received_connections, class_name: "Connection", foreign_key: "connectee_id"

  def role?(role)
    self.role.to_s == role.to_s
  end

  def name
    self.first_name + ' ' + self.last_name
  end

  def short_name
    self.first_name + ' ' + self.last_name[0] + '.'
  end

  def connections
    self.made_connections + self.received_connections
  end

  # Fill array with ids of users to whom a particular user
  # is connected, returning that array

  def primary_connections
    if !@primary_connections_hash
      connections_ids = []
      self.made_connections.each do |connection|
        connections_ids << connection.connectee_id
      end
      self.received_connections.each do |connection|
        connections_ids << connection.connecter_id
      end
      @primary_connections_hash = {primary: connections_ids.uniq}
    end
    @primary_connections_hash || {}
  end

  # Fill array with ids of users to whom a particular user
  # is secondarily connected/connected by another user
  # returning that array

  def secondary_connections
    if !@secondary_connections_hash
      secondary_connections_ids = []
      primary_connections[:primary].each do |connection_id|
        connection = User.find(connection_id)
        secondary_connections_ids += connection.primary_connections[:primary]
      end
      secondary_connections_ids -= primary_connections[:primary]
      @secondary_connections_hash = {secondary: secondary_connections_ids.uniq}
    end
    @secondary_connections_hash || {}
  end

  # Fill array with ids of users to whom a particular user
  # is tertiarily connected, returning that array.
  # Given repeat with above method, could be dried up.

  # See comment above ids_of_all_connections (below) to understand
  # the optional array parameter.

  def tertiary_connections(all=[])
    if !@tertiary_connections_hash
      primary_and_secondary_connections_ids = primary_connections[:primary] + secondary_connections[:secondary]
      tertiary_connections_ids = []
      secondary_connections[:secondary].each do |connection_id|
        connection = User.find(connection_id)
        tertiary_connections_ids += connection.primary_connections[:primary]
      end
      tertiary_connections_ids -= primary_and_secondary_connections_ids
      @tertiary_connections_hash = {tertiary: tertiary_connections_ids.uniq}
    end
    @tertiary_connections_hash || {}
  end

  def all_connections
    connections_hash = {}
    connections_hash.merge! primary_connections
    connections_hash.merge! secondary_connections
    connections_hash.merge! tertiary_connections
  end

  # TODO: Determine which method to call to get posts by user_id

  def posts_of_connections(ids)
    Post.where(user_id: ids)
  end

  def posts_of_connections_for_a_category(ids, category_id)
    Post.where(user_id: ids, category_id: category_id)
  end
end
