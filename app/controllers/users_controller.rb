class UsersController < ApplicationController
  # GET /users/new
  def new
    @current_user = User.new
  end

=begin
  def logout
    session[:name] = nil
    redirect_to '/users/new', notice: 'Logout successful.'
  end

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
    @current_user = User.find(params[:id])
  end

  # POST /users
  def create
    @current_user = User.find_by_name(params[:user][:name])
    if @current_user
      redirect_after_create
    else
      @current_user = User.new(params[:user])
      if @current_user.save
        redirect_after_create
      else
        render action: "new"
      end
    end
  end

  private

  def redirect_after_create
    path = session.delete(:redirect_path) || '/my'
    redirect_to path, notice: 'Login successful.'
    session[:name] = @current_user.name
  end
=end
end
