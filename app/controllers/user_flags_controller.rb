class UserFlagsController < ApplicationController

  load_and_authorize_resource

  def create
    user_flag = UserFlag.new
    user_flag.flagger_id = params[:flagger_id].to_i
    user_flag.flagged_id = params[:flagged_id].to_i
    if user_flag.save
      redirect_to user_home_path(current_user), notice: "User flagged. We will review."
    else
      redirect_to user_home_path(current_user), notice: user_flag.errors_for_redirect
    end
  end

  def destroy
  end

end
