class MyController < ApplicationController
  def index
    login_required
  end
end
