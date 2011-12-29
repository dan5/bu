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
      #redirect_to @user, notice: 'Login successful.'
      redirect_to '/my', notice: 'Login successful.'
    else
      @user = User.new(params[:user])
      respond_to do |format|
        if @user.save
          format.html { redirect_to @user, notice: 'User was successfully created.' }
        else
          format.html { render action: "new" }
        end
      end
    end
  end
end
