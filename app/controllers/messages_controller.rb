class MessagesController < ApplicationController

  load_and_authorize_resource

  def index
    current_user.mark_unviewed_messages_viewed

    @q = current_user.messages.search(params[:q])
    @messages = @q.result(distinct: true)
  end

  def new
    @message = Message.new
    @sender_id = params[:sender_id]
    @recipient_id = params[:recipient_id]
  end

  def create
    if @message.save
      redirect_to messages_path, notice: "Message sent."
    else
      render 'new'
    end
  end

  def destroy
    @message = Message.find(params[:id])

    @message.toggle_readability_or_destroy(current_user)

    redirect_to messages_path, notice: "Message deleted."
  end

end
