# thx: http://d.hatena.ne.jp/kaorumori/20111113/1321155791
class SessionsController < ApplicationController
  def callback
    auth = request.env['omniauth.auth']
    user = User.find_by_provider_and_uid(auth['provider'], auth['uid']) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    path = session.delete(:redirect_path) || '/my'
    redirect_to path, notice: 'Login successful.'
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
