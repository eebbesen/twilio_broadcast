# frozen_string_literal: true

##
class Message < ApplicationRecord
  validates :content, presence: true, length: { minimum: 5 }
  belongs_to :user
  has_many :message_recipients
  has_many :recipients, through: :message_recipients
  has_many :message_recipient_lists
  has_many :recipient_lists, through: :message_recipient_lists

  def recipient_list_active?(recipient_list_id)
    !recipient_lists.where(id: recipient_list_id).count.zero?
  end
end
