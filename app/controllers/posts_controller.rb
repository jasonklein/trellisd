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
    keyword_titles = params[:keywords].split(%r{,\s*}).map(&:downcase).uniq
    
    @post.add_keywords(keyword_titles)

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
    keyword_titles = params[:keywords].split(%r{,\s*}).map(&:downcase).uniq

    @post.add_keywords(keyword_titles)

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
