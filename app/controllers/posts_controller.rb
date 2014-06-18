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
    post_keywords = params[:keywords].split(%r{,\s*}).map(&:downcase).uniq
    post_keywords.each do |post_keyword|
      keyword = Keyword.where(title: post_keyword).first_or_create
      @post.keywords << keyword
    end

    if @post.save
      @post.make_matches
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
    post_keywords = params[:keywords].split(%r{,\s*}).map(&:downcase).uniq
    post_keywords.each do |post_keyword|
      keyword = Keyword.where(title: post_keyword).first_or_create
      @post.keywords << keyword
    end

    @post.keywords = @post.keywords.uniq

    if @post.update_attributes(params[:post])
      @post.make_matches
      redirect_to user_post_path(@post.user, @post)
    else
      render 'edit'
    end
  end

  def destroy
    post = Post.find(params[:id])
    post_id = post.id

    post.destroy_keywords_posts
    Post.destroy(post)
    
    redirect_to user_path(current_user), notice: "Post deleted."
  end
  

end
