class UsersChannel < ApplicationCable::Channel
  def subscribed
    # Stream for user online status updates
    stream_from "users:online_status"
  end

  def update_online_status(data)
    # Broadcast the updated online status to all subscribers
    ActionCable.server.broadcast("users:online_status", data)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
