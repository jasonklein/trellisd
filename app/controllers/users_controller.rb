class UsersController < ApplicationController

  load_and_authorize_resource
  
  def home
    @user = current_user
    @all_connections = @user.all_connections
    @posts = @user.posts_of_all_connections(@user.all_connections_ids).limit(10)
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
