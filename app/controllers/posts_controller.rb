class PostsController < ApplicationController
  
  before_filter :authenticate_user!
  load_and_authorize_resource :user
  load_and_authorize_resource through: :user

  def index
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
