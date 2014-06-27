module ConnectionsHelper
  def display_suggested_connections_index(suggested_connections)
    if suggested_connections.any?
      render partial: 'suggested_connections_index', locals: {suggested_connections: suggested_connections}
    end
  end

  def display_connections_index(users)
    if users.any?
      render partial: 'connections_index', locals: {users: users}
    end
  end
end
