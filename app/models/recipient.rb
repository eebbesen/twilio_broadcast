# frozen_string_literal: true

##
class Recipient < ApplicationRecord
  validates_presence_of :phone
  belongs_to :user
  has_many :recipient_list_members
  has_many :recipient_lists, through: :recipient_list_members
  has_many :message_recipients
  has_many :messages, through: :message_recipients

  def on_recipient_list?(recipient_list_id)
    recipient_list_ids.include? recipient_list_id
  end
end
