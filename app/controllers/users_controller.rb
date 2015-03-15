require 'open-uri'
class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :set_user_by_id, only: :show

  # GET /users
  # GET /users.json
  def index
    redirect_to root_path
  end

  # GET /users/1
  # GET /users/1.json
  def show
    # 未登録ユーザの検出
    if @user.nil?
      unless user_signed_in?
        flash[:alert] = 'You must sign in to search user who unregisterd to StarCaster.'
        redirect_to root_path and return
      end

      show_sid = params[:id]
      yourself = current_user
      tw = Twitter::REST::Client.new do |config|
        config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
        config.access_token = yourself.tw_key
        config.access_token_secret = yourself.tw_secret
      end
      begin
        show_user = tw.user(show_sid)
        @user = User.new(
            tw_uid: show_user.id,
            tw_sid: show_user.screen_name,
            tw_name: show_user.name,
            name: show_user.name,
            image: show_user.attrs[:profile_image_url].sub('_normal', ''),
        )

        responses = tw.favorites(show_sid, count: 200)

        @urls = Array.new
        @media = Array.new
        responses.each do |status|
          next if status.attrs[:user][:protected]
          if status.urls?
            @urls << Tweet.new(
                post_id: status.id,
                text: status.text,
                user_name: status.attrs[:user][:name],
                user_sid: status.attrs[:user][:screen_name],
                user_uid: status.attrs[:user][:id_str],
                user_image: status.attrs[:user][:profile_image_url].sub('_normal', ''),
                tweeted_at: status.attrs[:created_at],
                urls: status.urls.map{|url| Url.new(url: url.attrs[:url])}
            )
          elsif status.media?
            @media << Tweet.new(
                post_id: status.id,
                text: status.text,
                user_name: status.attrs[:user][:name],
                user_sid: status.attrs[:user][:screen_name],
                user_uid: status.attrs[:user][:id_str],
                user_image: status.attrs[:user][:profile_image_url].sub('_normal', ''),
                tweeted_at: status.attrs[:created_at],
                media: status.media.map{|medium| Medium.new(url: medium.media_url.to_s)}
            )
          end
        end
      rescue Twitter::Error::NotFound
        flash[:alert] = 'User not found in Twitter.'
        redirect_to root_path and return
      rescue Exception
        flash[:alert] = 'Rate Limited in Twitter.'
        redirect_to root_path and return
      end
    else
      @urls = Tweet.joins(:urls, favorite: :user).where(users: {id: @user.id}).order(tweeted_at: :desc)
      @media = Tweet.joins(:media, favorite: :user).where(users: {id: @user.id}).uniq.order(tweeted_at: :desc)
    end
  end

  def setting
    @user = current_user
  end

  def fetch
    unless user_signed_in? || session[:fetching]
      return
    end

    session[:fetching] = true
    @user = current_user

    tw = Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token = @user.tw_key
      config.access_token_secret = @user.tw_secret
    end

    responses = []
    begin
      if @user.preset_fav.present?
        preset = @user.preset_fav
        responses += res = tw.favorites(count: 200, since_id: preset)
        5.times do
          id = res[-1].id - 1
          responses += res = tw.favorites(count: 200, max_id: id, since_id: preset)
          break if res.empty?
        end
        if responses[0].present?
          @user.preset_fav = responses[0].id
          @user.save
        end
      else
        responses += res = tw.favorites(count: 200)
        5.times do
          id = res[-1].id - 1
          responses += res = tw.favorites(count: 200, max_id: id)
        end
        @user.preset_fav = responses[0].id
        @user.save
      end
    rescue
    end

    favorites = []
    responses.each do |status|
      next unless status.urls? or status.media?
      next if status.attrs[:user][:protected]
      favorite = {
          user: @user,
          tweet: Tweet.new(
              post_id: status.id,
              text: status.text,
              user_name: status.attrs[:user][:name],
              user_sid: status.attrs[:user][:screen_name],
              user_uid: status.attrs[:user][:id_str],
              user_image: status.attrs[:user][:profile_image_url].sub('_normal', ''),
              tweeted_at: status.attrs[:created_at],
              media: status.media.map{|medium| Medium.new(url: medium.media_url.to_s)},
              urls: status.urls.map{|url| Url.new(url: url.attrs[:url])}
          )
      }
      Favorite.create(favorite)
    end
    session[:fetching] = false

    # redirect_to controller: :welcome, action: :index
    render nothing: true
  end

  def save
    # provider = params[:provider]
    # url = params[:url]
    # user = current_user
    # unless [provider, url, user].include?(nil)
    #   case provider
    #   when 'hatena'
    #     unless @hatena
    #       credentials = Hatena::Bookmark::Restful::V1::Credentials.new(
    #           consumer_key: ENV['HATENA_CONSUMER_KEY'],
    #           consumer_secret: ENV['HATENA_CONSUMER_SECRET'],
    #           access_token: user.h_key,
    #           access_token_secret: user.h_secret
    #       )
    #       @hatena = Hatena::Bookmark::Restful::V1.new(credentials)
    #     end
    #
    #     @hatena.create_bookmark(url)
    #   when 'pocket'
    #     unless @pocket
    #
    #     end
    #   when 'qiita'
    #
    #   end
    # end

    render nothing: true
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def _fetch

    end

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def set_user_by_id
      @user = User.find_by(tw_sid: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :tw_name, :tw_sid, :tw_uid, :tw_key, :tw_secret, :provider)
    end
end
