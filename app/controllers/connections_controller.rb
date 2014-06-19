class ConnectionsController < ApplicationController
  
  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    user_ids = current_user.get_user_ids_from_connections_across_states
    @users = User.where(id: user_ids)
  end

  def connect
    connecter_id = current_user.id
    connectee_id = params[:connection][:connectee_id]
    if !Connection.where(connecter_id: connecter_id, connectee_id: connectee_id).any?
      if @connection = Connection.create(connecter_id: connecter_id, connectee_id: connectee_id)
        redirect_to connections_path, notice: 'Connection requested.'
      end
    else
      redirect_to connections_path, notice: 'Error in connection request. Please try again.'
    end
  end

  def accept
    raise
  end

  def destroy
    Connection.destroy(params[:id])
    redirect_to connections_path, notice: "Disconnected."
  end
end
