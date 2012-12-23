class SessionsController < ApplicationController
  def callback
    user = User.find_or_create_with_omniauth(request.env['omniauth.auth'])
    session[:user_id] = user.id

    redirect_to redirect_path, notice: 'Login successful.'
  end

  def destroy
    session[:user_id] = nil

    redirect_to root_path
  end

  private
  def redirect_path
    session.delete(:redirect_path) || my_url
  end
end
