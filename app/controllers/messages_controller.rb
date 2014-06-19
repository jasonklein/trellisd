class MessagesController < ApplicationController

  load_and_authorize_resource

  def index
    current_user.mark_unviewed_messages_viewed

    @q = current_user.messages.search(params[:q])
    @messages = @q.result(distinct: true)
  end

  def new
  end

  def create
  end

  def destroy
  end

end
