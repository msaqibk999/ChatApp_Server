# app/workers/push_notification_worker.rb
class PushNotificationWorker
    include Sidekiq::Worker
  
    def perform(message_id)
      message = Message.find_by(id: message_id)
      return unless message
  
      fcm_client = FCM.new("AAAAwofN3Qw:APA91bEa2yuCAQtFKElEUtr6R17c76klDWhzLM27UAKxQ4m_3kg7QKs5N2doadHPHRl3JDvz1qR8aSQI0axq4-Yki_8bYBQFU-2RbHA4zQliGqh-RMCeh8yizgyIKzjke-iR7tRUYqOM")
      options = {
        priority: 'high',
        data: { message: message.body },
        notification: {
          icon: "https://cdn3d.iconscout.com/3d/premium/thumb/chat-talking-5143250-4312620.png",
          title: "New Message from #{message.sender}",
          body: message.body,
          click_action: "https://6a981bd7.chatapp-client.pages.dev/",
          sound: 'default',
        }
      }
  
      tokens = User.where.not(token: nil).pluck(:token)
      tokens.each_slice(20) do |token_slice|
        response = fcm_client.send(token_slice, options)
        puts response
      end
    end
  end
  