class Identity < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :uid, :user_id

  validates_presence_of :uid, :provider, :user_id
  validates_uniqueness_of :uid, :scope => :provider

  def self.from_omniauth(data)
    binding.pry  
    if identity = Identity.where(provider: data.provider, uid: data.uid).first
      identity
    else
      user = User.where(email: data.info.email).first
      # _or_create do |user|
      #   user.password = Devise.friendly_token[0,20]
      #   user.first_name = data.info.first_name
      #   user.last_name = data.info.last_name
      # end
      binding.pry
      if user
        identity = Identity.create(user_id: user.id, provider: data.provider, uid: data.uid)
        identity
      else
        nil
      end
    end
  end
end
