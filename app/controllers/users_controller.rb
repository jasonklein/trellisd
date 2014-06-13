class UsersController < ApplicationController
  
  def home
    @user = current_user
    @posts = Post.where(ids: )
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
