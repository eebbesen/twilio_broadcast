# frozen_string_literal: true

##
class Recipient < ApplicationRecord
  validates_presence_of :phone
  belongs_to :user
  has_many :recipient_list_members
  has_many :recipient_lists, through: :recipient_list_members
  has_many :message_recipients
  has_many :messages, through: :message_recipients

  before_save { self.phone = Recipient.normalize_phone(phone) }

  scope :available, -> { where(removed: false) }

  def on_recipient_list?(recipient_list_id)
    recipient_list_ids.include? recipient_list_id
  end

  # Convert all phone numbers to E.164 formatting
  # https://support.twilio.com/hc/en-us/articles/223183008-Formatting-International-Phone-Numbers
  def self.normalize_phone(phone)
    if phone.starts_with?('+1')
      phone
    elsif phone.starts_with?('1')
      "+#{phone}"
    else
      "+1#{phone}"
    end
  end

  # since we don't want to destroy records for sent messages
  # we don't just destroy if there have been sends
  def remove
    recipient_list_members.destroy_all
    if message_recipients.count.zero?
      destroy
    else
      self.removed = true
      save!
    end
  end
end
