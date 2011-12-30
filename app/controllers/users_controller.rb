class UsersController < ApplicationController
  def logout
    session[:name] = nil
    redirect_to '/', notice: 'Logout successful.'
  end

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  def create
    @user = User.find_by_name(params[:user][:name])
    if @user or @user = User.create(params[:user])
      session[:name] = @user.name
      redirect_to '/my', notice: 'Login successful.'
    else
      render action: "new"
    end
  end
end
