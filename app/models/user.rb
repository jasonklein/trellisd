class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, :birthday, :image, :city, :postcode, :bio, :role

  mount_uploader :image, UserImageUploader

  validates :first_name, :last_name, presence: true
  validates :bio, length: { maximum: 300, too_long: '%{count} characters is the maximum allowed' }, allow_blank: true
  validates :first_name, :last_name, length: { minimum: 2 }

  has_many :posts

  has_many :made_flags, class_name: 'UserFlag', foreign_key: 'flagger_id'
  has_many :received_flags, class_name: 'UserFlag', foreign_key: 'flagged_id'

  has_many :made_connections, class_name: 'Connection', foreign_key: 'connecter_id'
  has_many :received_connections, class_name: 'Connection', foreign_key: 'connectee_id'

  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id'
  has_many :received_messages, class_name: 'Message', foreign_key: 'recipient_id'

  has_many :identities, dependent: :destroy

  has_many :suggested_connections
  has_many :received_suggested_connections, class_name: 'SuggestedConnection', foreign_key: 'connectee_id'

  accepts_nested_attributes_for :sent_messages
  accepts_nested_attributes_for :received_messages

  def role?(role)
    self.role.to_s == role.to_s
  end

  def name
    self.first_name + ' ' + self.last_name
  end

  def short_name
    self.first_name + ' ' + self.last_name[0] + '.'
  end

  def pending_received_connections
    self.received_connections.where(state: :pending)
  end

  def accepted_connections
    self.made_connections.where(state: :accepted) + self.received_connections.where(state: :accepted)
  end

  def connections_across_states
    self.made_connections + self.received_connections
  end

  def get_user_ids_from_connections_across_states
    connections = connections_across_states
    user_ids = []
    connections.each do |connection|
      user_ids << connection.connectee_id
      user_ids << connection.connecter_id
    end
    user_ids = user_ids.uniq.reject { |user_id| user_id == self.id }
  end

  # Fill array with ids of users to whom a particular user
  # is connected, returning that array

  def primary_connections
    if !@primary_connections_hash
      connections_ids = []
      self.accepted_connections.each do |connection|
        connections_ids << connection.connectee_id
        connections_ids << connection.connecter_id
      end
      connections_ids = connections_ids.reject { |connetion_id| connetion_id == self.id }
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
      secondary_connections_ids -= (primary_connections[:primary] + [self.id])
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
      tertiary_connections_ids -= (primary_and_secondary_connections_ids + [self.id])
      @tertiary_connections_hash = {tertiary: tertiary_connections_ids.uniq}
    end
    @tertiary_connections_hash || {}
  end

  ### N.B.: below is only all accepted connections

  def all_connections
    if !@connections_hash
      @connections_hash = {}
      @connections_hash.merge! primary_connections
      @connections_hash.merge! secondary_connections
      @connections_hash.merge! tertiary_connections
    end
    @connections_hash
  end

  def connections_ids(connections)
    connections_ids = []
    connections.each do |key, ids|
      connections_ids += ids
    end
    connections_ids
  end

  ### TODO: eliminate below method in favor of above method to DRY code

  ### N.B.: below is only all accepted connections

  def all_connections_ids
    connections_ids = []
    all_connections.each do |key, ids|
      connections_ids += ids
    end
    connections_ids
  end

  ### N.B.: below is only w/r/t all accepted connections

  def posts_of_all_connections(ids)
    if !@connections_posts  
      @connections_posts = Post.where(user_id: ids)
    end
    @connections_posts
  end

  ### N.B.: below is only w/r/t all accepted connections

  def posts_of_connections_for_a_category(ids, category_id)
    posts_of_all_connections(ids).where(category_id: category_id)
  end

  def matching_ids_for_all_posts
    if !@matching_ids
      @matching_ids = []
      posts.each do |post|
        post.matches.each do |match|
          @matching_ids << match.matching_id
        end
      end
    end
    @matching_ids = @matching_ids.compact.uniq
    @matching_ids
  end

  ransacker :full_name do |parent|
    Arel::Nodes::InfixOperation.new('||',
      parent.table[:first_name], parent.table[:last_name])
  end

  ransacker :full_name do |parent|
    Arel::Nodes::NamedFunction.new('concat_ws',
      [' ', parent.table[:first_name], parent.table[:last_name]])
  end

  ransacker :full_name, formatter: proc { |v| v.mb_chars.downcase.to_s } do |parent|
    Arel::Nodes::NamedFunction.new('LOWER',
      [Arel::Nodes::NamedFunction.new('concat_ws',
        [' ', parent.table[:first_name], parent.table[:last_name]])])
  end

  def messages
    sent_ids = Message.where(sender_id: self.id, sender_readability: true)
    received_ids = Message.where(recipient_id: self.id, recipient_readability: true)
    ids = sent_ids + received_ids
    Message.where(id: ids)
  end

  def unviewed_messages
    self.received_messages.unviewed
  end

  def mark_unviewed_messages_viewed
    self.unviewed_messages.each do |message|
      message.update_attributes(viewed: true)
    end
  end

end
