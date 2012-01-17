class SettingsController < ApplicationController
  def language
    session[:language] = params[:language]
    redirect_to :back
  end

  def account
    login_required
  end
end
