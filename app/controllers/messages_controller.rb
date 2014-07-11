class MessagesController < ApplicationController

  before_filter :get_request_url
  load_and_authorize_resource

  def index
    current_user.mark_unviewed_messages_viewed

    @q = current_user.messages.search(params[:q])
    @messages = @q.result(distinct: true).includes(:sender, :recipient)

    respond_to do |format|
      format.js
      format.html
    end
  end

  def new
    @message = Message.new
    @sender_id = params[:sender_id]
    @recipient_id = params[:recipient_id]
    if params[:post_id].to_i == 0
      @subject = ''
    else
      @post = Post.find(params[:post_id])
      @subject = @post.title
      @post_content = @post.content
    end
  end

  def create
    if @message.save
      UserMailer.notify_user_of_message(@message).deliver
      redirect_to messages_path, notice: "Message sent."
    else
      render 'new'
    end
  end

  def reply
    original_message = Message.find(params[:id])
    if original_message.subject.start_with?('Re: ')
      @subject = original_message.subject
    else
      @subject = 'Re: ' + original_message.subject
    end

    @sender_id = current_user.id

    if original_message.sender == current_user
      @recipient_id = original_message.recipient_id
    else
      @recipient_id = original_message.sender_id
    end
    
    @original_content = original_message.content
  end

  def create_reply
    @message = Message.new(params[:message])

    if @message.save
      UserMailer.notify_user_of_message(@message).deliver
      redirect_to messages_path, notice: "Reply sent."
    else
      render 'reply'
    end
  end

  def destroy
    @message = Message.find(params[:id])

    @message.toggle_readability_or_destroy(current_user)

    redirect_to messages_path, notice: "Message deleted."
  end

end
