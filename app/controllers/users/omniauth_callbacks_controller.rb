class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    @user = User.find_for_twitter_oauth(auth_hash)
    session["twitter.info"] = auth_hash.info
    sign_in_and_redirect @user, event: :authentication
  end

  protected
  def auth_hash
    request.env['omniauth.auth']
  end
end
