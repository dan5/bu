class WelcomeController < ApplicationController
  def index
    @groups = Group.all
  end
end
