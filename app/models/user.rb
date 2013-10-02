class User < ActiveRecord::Base
  devise :trackable, :omniauthable

  class << self
    def find_for_twitter_oauth(auth, signed_in_resource=nil)
      User.where(provider: auth.provider, uid: auth.uid)
        .first_or_create(name: auth.info.nickname)
    end
  end
end
