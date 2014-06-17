class UsersController < ApplicationController

  load_and_authorize_resource
  
  def home
    @posts = current_user.posts_of_all_connections(current_user.all_connections_ids).limit(10)
  end

  def index
    @users = User.includes(:posts)
  end

  def show
    @posts = @user.posts
  end

  def settings
    @user = current_user
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      redirect_to user_settings_path @user, notice: "Successfully updated!"
    else
      render 'edit'
    end
  end

  def destroy
  end
end
