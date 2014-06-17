class PostsController < ApplicationController
  
  before_filter :authenticate_user!
  load_and_authorize_resource :user
  load_and_authorize_resource through: :user

  def index
  end

  def new
    @user = current_user
  end

  def create
    if @post.save
      redirect_to user_post_path(@post.user, @post)
    else
      render 'new'
    end
  end

  def show
    @user = @post.user
  end

  def edit
    @user = @post.user
  end

  def update
    if @post.update_attributes(params[:post])
      redirect_to user_post_path(@post.user, @post)
    else
      render 'edit'
    end
  end

  def destroy
  end
end
