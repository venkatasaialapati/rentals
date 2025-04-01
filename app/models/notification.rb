class Notification < ApplicationRecord
  belongs_to :user

  after_create_commit :broadcast_notification

  private

  def broadcast_notification
    ActionCable.server.broadcast("notifications_#{user.id}", { message: message })
  end
end
