class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    @user = User.find_or_create_by(user_params)

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, :kind => "Twitter") if is_navigational_format?
    else
      session["devise.twitter_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def hatena
    if user_signed_in?
      @user = current_user
      req = request.env["omniauth.auth"]
      auth = {
        h_id: req['uid'],
        h_key: req['credentials']['token'],
        h_secret: req['credentials']['secret']
      }
      @user.update(auth)
      redirect_to '/users/setting'
    else
      redirect_to root_path
    end
  end

  def pocket
    if user_signed_in?
      @user = current_user
      req = request.env["omniauth.auth"]
      auth = {
        p_id: req['uid'],
        p_key: req['credentials']['token']
      }
      @user.update(auth)
      redirect_to '/users/setting'
    else
      redirect_to root_path
    end
  end

  def qiita
    if user_signed_in?
      @user = current_user
      req = request.env["omniauth.auth"]
      auth = {
        q_id: req['uid'],
        q_key: req['credentials']['token']
      }
      binding.pry
      @user.update(auth)
      redirect_to '/users/setting'
    else
      redirect_to root_path
    end
  end

  private
  def user_params
    req = request.env["omniauth.auth"]
    user = {
      provider: req['provider'],
      tw_uid: req['uid'],
      tw_sid: req['info']['nickname'],
      tw_name: req['info']['name'],
      tw_key: req['credentials']['token'],
      tw_secret: req['credentials']['secret'],
      name: req['info']['name'],
      image: req['info']['image'].sub('_normal', ''),
    }
  end
end