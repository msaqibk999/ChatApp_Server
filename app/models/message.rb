class Message < ApplicationRecord
    belongs_to :user, foreign_key: :sender, primary_key: :phone_number, optional: true

    validates :body, presence: true
    validates :sender, presence: true, length: { minimum: 10 }
    after_create_commit :broadcast_message
    after_create :enqueue_push_notifications
  
    private
  
    def broadcast_message
      ActionCable.server.broadcast("MessagesChannel", {
        id: self.id,
        sender: self.user.phone_number,
        body: self.body,
        time: self.created_at
      })
    end

    def enqueue_push_notifications
      PushNotificationWorker.perform_async(self.id)
    end

  end