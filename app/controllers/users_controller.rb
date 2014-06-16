class UsersController < ApplicationController

  load_and_authorize_resource
  
  def home
    @all_connections = current_user.all_connections
    @posts = current_user.posts_of_all_connections(current_user.all_connections_ids).limit(10)
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
