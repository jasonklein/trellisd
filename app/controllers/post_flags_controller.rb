class PostFlagsController < ApplicationController
  load_and_authorize_resource

  def create
    post_flag = PostFlag.new
    post_flag.flagger_id = params[:flagger_id].to_i
    post_flag.post_id = params[:post_id].to_i
    if post_flag.save
      redirect_to post_home_path(current_user), notice: "Post flagged. We will review."
    else
      redirect_to post_home_path(current_user), notice: post_flag.errors_for_redirect
    end
  end

  def destroy
  end
end
