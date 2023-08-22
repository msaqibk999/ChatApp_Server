class Message < ApplicationRecord
    belongs_to :user, foreign_key: :sender, primary_key: :phone_number, optional: true

    validates :body, presence: true
    validates :sender, presence: true, length: { minimum: 10 }
    after_create_commit :broadcast_message
  
    private
  
    def broadcast_message
      ActionCable.server.broadcast("MessagesChannel", {
        id: self.id,
        sender: self.user.phone_number,
        body: self.body,
        time: self.created_at
      })
    end

    def send_push_notifications
      fcm_client = FCM.new("AAAAwofN3Qw:APA91bEa2yuCAQtFKElEUtr6R17c76klDWhzLM27UAKxQ4m_3kg7QKs5N2doadHPHRl3JDvz1qR8aSQI0axq4-Yki_8bYBQFU-2RbHA4zQliGqh-RMCeh8yizgyIKzjke-iR7tRUYqOM")
  
      options = {
        priority: 'high',
        data: { message: self.body },
        notification: {
          title: "New Message from #{self.sender}",
          body: self.body,
          sound: 'default',
        }
      }
  
      User.where.not(token: nil).find_each(batch_size: 20) do |user|
        puts user.token
        response = fcm_client.send([user.token], options)
        puts response
      end
    end

  end