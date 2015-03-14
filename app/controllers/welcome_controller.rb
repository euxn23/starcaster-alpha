class WelcomeController < ApplicationController
  def index
    if user_signed_in?
      @user = current_user
      if session[:fetching]
        flash[:notice] = 'Twitterより更新中...'
        render template: 'users/show'
      else
        @urls = Tweet.joins(:urls, favorite: :user).where(users: {id: @user.id}).order(tweeted_at: :desc)
        @media = Tweet.joins(:media, favorite: :user).where(users: {id: @user.id}).uniq.order(tweeted_at: :desc)

        if @urls.empty? && @media.empty?
          redirect_to controller: :users, action: :setting
        else
          render template: 'users/show'
        end
      end
    else
      render :introduction, layout: 'introduction'
    end
  end

  def introduction
  end
end
