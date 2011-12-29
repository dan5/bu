class UsersController < ApplicationController
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
    if @user
      session[:name] = @user.name
      redirect_to '/my', notice: 'Login successful.'
    else
      @user = User.new(params[:user])
      if @user.save
        session[:name] = @user.name
        redirect_to @user, notice: 'User was successfully created.'
      else
        render action: "new"
      end
    end
  end
end
