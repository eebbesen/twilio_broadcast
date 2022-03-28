# frozen_string_literal: true

##
class Message < ApplicationRecord
  validates :content, presence: true, length: { minimum: 5 }
  belongs_to :user
  has_many :message_recipients
  has_many :recipients, through: :message_recipients
  has_many :message_recipient_lists, dependent: :delete_all
  has_many :recipient_lists, through: :message_recipient_lists

  scope :pending, -> { where(status: 'Pending') }
  scope :ready_to_send, -> { pending.where('send_time < ?', DateTime.now) }

  def recipient_list_active?(recipient_list_id)
    !recipient_lists.where(id: recipient_list_id).count.zero?
  end

  def sent?
    %w[Sent queued].include? status
  end

  def recipients?
    recipient_lists.find { |rl| break rl.recipients.count if rl.recipients.count.positive? }
  end

  def remove
    raise SentMessageError, 'You cannot delete a message that has been sent' if sent?

    destroy
  end
end

class SentMessageError < StandardError
end
