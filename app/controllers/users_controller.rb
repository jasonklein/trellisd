class UsersController < ApplicationController

  load_and_authorize_resource
  
  def home
    @user = current_user
    @posts = @user.posts_of_connections.limit(10)
  end

  def index
    @users = User.includes(:posts)
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
