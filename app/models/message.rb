class Message < ApplicationRecord
    validates :body, presence: true
    validates :sender, presence: true, length: { minimum: 10 }
    after_create_commit :broadcast_message
  
    private
  
    def broadcast_message
      ActionCable.server.broadcast("MessagesChannel", {
        id: self.id,
        sender: self.sender,
        body: self.body
      })
    end
  end