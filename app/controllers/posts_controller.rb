class PostsController < ApplicationController
  
  before_filter :get_request_url
  before_filter :authenticate_user!, except: [:index, :category_index, :show]
  load_and_authorize_resource

  skip_authorize_resource only: :index

  def index
    referrer_url = request.env['HTTP_REFERER']
    divider = 'categories/'
    if referrer_url && referrer_url.include?(divider)
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
      
    @posts = @q.result(distinct: true).includes(:keywords).page(params[:page])

    render_layout_for_post_views
  end

  def category_index
    title = params[:title]
    if category_id = Category.where(title: title).first.id
      @q = Post.where(category_id: category_id).search(params[:q])
    else
      @q = Post.search(params[:q])
    end

    @posts = @q.result(distinct: true).includes(:keywords).page(params[:page])

    render_layout_for_post_views
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
    render_layout_for_post_views
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

  def render_layout_for_post_views
    if !current_user
      if params[:action] == 'show'
        render layout: 'pages_layout'
      elsif params[:action] == 'index' || params[:action] == 'category_index'
        respond_to do |format|
          format.js { render layout: "posts_index_for_non_current_user", template: "posts/index" }
          format.html { render layout: "posts_index_for_non_current_user", template: "posts/index" }
        end
      end
    else
      if params[:action] == 'index' || params[:action] == 'category_index'
        respond_to do |format|
          format.js { render layout: "posts_index", template: "posts/index" }
          format.html { render layout: "posts_index", template: "posts/index" }
        end
      end
    end
  end
  

end
