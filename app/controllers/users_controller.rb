class UsersController < ApplicationController
  before_filter :login_required, :only => [:edit, :update]
  # GET /users/1
  def show
    @current_user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @current_user = User.new
  end

  # GET /users/edit
  def edit
  end

  # PUT /users/1
  def update
    if @user.update_attributes(params[:user])
      redirect_to '/users/edit', notice: 'User was successfully updated.'
    else
      render :edit
    end
  end
end
