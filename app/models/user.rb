class User < ApplicationRecord
    has_many :messages, foreign_key: :sender, primary_key: :phone_number
    validates :phone_number, presence: true, uniqueness: true

    enum status: { online: 'online', typing: 'typing', offline: 'offline' }

    after_update_commit :broadcast_status_update

    private

    def broadcast_status_update
        data = { phone_number: phone_number, status: status }
        ActionCable.server.broadcast("users:status", data)
    end

  end