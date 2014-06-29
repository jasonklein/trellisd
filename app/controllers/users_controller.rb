class UsersController < ApplicationController

  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def home
    @user = current_user
    @posts = @user.posts_of_all_connections(@user.all_connections_ids).page(params[:page]).per(10)

    respond_to do |format|
      format.js
      format.html
    end
  end

  def index
    @q = User.search(params[:q])
    if params[:q] && !params[:q][:first_name_or_last_name_or_full_name_cont].blank?
      @users = @q.result(distinct: true)
    else
      @users = []
    end

    respond_to do |format|
      format.js
      format.html
    end
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
