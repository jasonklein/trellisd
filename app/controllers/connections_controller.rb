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
      else
        redirect_to connections_path, notice: 'Error in connection request. Please try again later.'
      end
    else
      redirect_to connections_path, notice: 'You are already connected to that user.'
    end
  end

  def accept
    connection = Connection.find(params[:id])
    if connection.update_attributes(state: :accepted)
      redirect_to connections_path, notice: "Connection accepted."
    else
      redirect_to connections_path, notice: "Something went wrong. Please try again later."
    end
  end

  def destroy
    connection = Connection.find(params[:id])
    Connection.destroy(params[:id])
    if connection.state == 'pending'
      redirect_to connections_path, notice: 'Connection request deleted.'
    else
      redirect_to connections_path, notice: 'Disconnected.'
    end
  end
end
