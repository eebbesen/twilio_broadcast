# frozen_string_literal: true

##
class Recipient < ApplicationRecord
  validates_presence_of :phone
  belongs_to :user
  has_many :recipient_list_members
  has_many :recipient_lists, through: :recipient_list_members
  has_many :message_recipients
  has_many :messages, through: :message_recipients

  before_save { self.phone = Recipient.normalize_phone(self.phone) }

  def on_recipient_list?(recipient_list_id)
    recipient_list_ids.include? recipient_list_id
  end

  # Convert all phone numbers to E.164 formatting
  # https://support.twilio.com/hc/en-us/articles/223183008-Formatting-International-Phone-Numbers
  def self.normalize_phone(phone)
    case
    when phone.starts_with?('+1')
      phone
    when phone.starts_with?('1')
      "+#{phone}"
    else
      "+1#{phone}"
    end
  end
end
