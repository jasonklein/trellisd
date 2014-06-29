class PostsController < ApplicationController
  
  before_filter :authenticate_user!
  load_and_authorize_resource

  skip_authorize_resource only: :index

  def index

    referrer_url = request.env['HTTP_REFERER']
    divider = 'categories/'
    if referrer_url.include?(divider)
      referrer_url_parts = referrer_url.split(divider)
      title = referrer_url_parts[1]
      if category_id = Category.where(title: title).first.id
        @q = Post.where(category_id: category_id).search(params[:q])
      else
        @q = Post.search(params[:q])
      end
    else
      @q = Post.search(params[:q])
    end
      
    @posts = @q.result(distinct: true).includes(:keywords)

    respond_to do |format|
      format.js { render layout: "posts_index" }
      format.html { render layout: "posts_index" }
    end
  end

  def category_index
    title = params[:title]
    category_id = Category.where(title: title).first.id

    @s = Post.where(category_id: category_id).search(params[:s])
    @posts = @s.result(distinct: true).includes(:keywords)

    respond_to do |format|
      format.js { render layout: "posts_index", template: "posts/category_index" }
      format.html { render layout: "posts_index", template: "posts/category_index" }
    end
  end

  def new
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
