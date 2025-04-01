class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notifications_#{current_user.id}" # Stream notifications for each user
  end

  def unsubscribed
    # Cleanup when channel is unsubscribed
  end
end
