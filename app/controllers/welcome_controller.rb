class WelcomeController < ApplicationController
  def index
    if user_signed_in?
      @user = current_user
      @urls = Tweet.joins(:urls, favorite: :user).where(users: {id: @user.id}).order(tweeted_at: :desc)
      @media = Tweet.joins(:media, favorite: :user).where(users: {id: @user.id}).uniq.order(tweeted_at: :desc)

      if @urls.empty? && @media.empty?
      # if true
        redirect_to controller: :users, action: :setting
      else
        render template: 'users/show'
      end
    else
      render :introduction, layout: 'introduction'
    end
  end

  def introduction
  end
end
