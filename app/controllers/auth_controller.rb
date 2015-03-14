class AuthController < ApplicationController
  def create
    authenticate_user!
    auth = request.env["omniauth.auth"]
    res = {}
  end

  def destroy
  end
end
