class WelcomeController < ApplicationController
  def index
    @groups = Group.find(:all, :conditions => ['permission <= 1'])
  end
end
