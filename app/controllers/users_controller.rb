class UsersController < ApplicationController
  
  def home
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
