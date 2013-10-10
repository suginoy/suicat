class User < ActiveRecord::Base
  devise :trackable, :omniauthable

  has_many :histories

  class << self
    def find_for_twitter_oauth(auth)
      User.where(provider: auth.provider, uid: auth.uid)
        .first_or_create(name: auth.info.nickname, key: Devise.friendly_token)
    end
  end
end
