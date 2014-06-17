class ConnectionsController < ApplicationController
  
  before_filter :authenticate_user!
  load_and_authorize_resource :user
  load_and_authorize_resource through: :user

  def index
  end
end
