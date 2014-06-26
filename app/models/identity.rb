class Identity < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :uid, :user_id

  validates_presence_of :uid, :provider, :user_id
  validates_uniqueness_of :uid, :scope => :provider

  def self.from_omniauth(data)
    if identity = Identity.where(provider: data.provider, uid: data.uid).first
      identity
    else
      user = User.where(email: data.info.email).first
      if user
        identity = Identity.create(user_id: user.id, provider: data.provider, uid: data.uid)
        identity
      else
        nil
      end
    end
  end
end
