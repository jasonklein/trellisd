class PostsController < ApplicationController
  
  before_filter :authenticate_user!
  load_and_authorize_resource

  skip_authorize_resource only: :index

  def index
    @q = Post.search(params[:q])
    @posts = @q.result(distinct: true).includes(:keywords)

    respond_to do |format|
      format.js { render layout: "posts_index" }
      format.html { render layout: "posts_index" }
    end
  end

  def category_index
    category_id = Category.where(title: params[:title]).first.id

    @q = Post.where(category_id: category_id).search(params[:q])
    @posts = @q.result(distinct: true).includes(:keywords)

    respond_to do |format|
      format.js { render layout: "posts_index", template: "posts/index" }
      format.html { render layout: "posts_index", template: "posts/index" }
    end
  end

  def new
    @user = current_user
  end

  def create
    
    keyword_titles = params[:keywords].split(%r{,\s*}).map(&:downcase).uniq 
    @post.add_keywords(keyword_titles)

    @post.user_id = current_user.id

    if @post.save
      @post.make_matches
      redirect_to post_path(@post)
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
      redirect_to post_path(@post)
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
