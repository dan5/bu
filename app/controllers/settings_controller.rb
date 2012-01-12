class SettingsController < ApplicationController
  def language
    session[:language] = params[:language]
    redirect_to :back
  end
end
