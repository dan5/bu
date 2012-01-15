class WelcomeController < ApplicationController
  def index
    @groups = Group.where('permission <= 1')
  end
end
