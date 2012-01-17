class UsersController < ApplicationController
  # GET /users/new
  def new
    @current_user = User.new
  end

  # GET /users/edit
  def edit
    login_required
  end

  # PUT /users/1
  def update
    login_required
    hash = {
      :name => params[:user][:name],
      :mail => params[:user][:mail],
    }
    if @user.update_attributes(hash)
      redirect_to '/users/edit', notice: 'User was successfully updated.'
    else
      render action: "edit"
    end
  end
end
