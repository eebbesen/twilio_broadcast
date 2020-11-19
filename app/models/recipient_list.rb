# frozen_string_literal: true

##
class RecipientList < ApplicationRecord
  validates_presence_of :name
  belongs_to :user
  has_many :recipient_list_members
  has_many :recipients, through: :recipient_list_members

  before_save { self.keyword = RecipientList.format_keyword(keyword) }

  scope :available, -> { where(removed: false) }

  def self.format_keyword(keyword)
    return unless keyword

    keyword.downcase
  end

  def remove
    unsent_messages.map(&:destroy)
    if sent_messages.count.positive?
      self.removed = true
      save!
    else
      recipient_list_members.destroy_all
      destroy
    end
  end

  private

  def sent_messages
    MessageRecipientList.where(recipient_list_id: id).select do |mrl|
      mrl.message.status == 'Sent'
    end
  end

  def unsent_messages
    MessageRecipientList.where(recipient_list_id: id).reject do |mrl|
      mrl.message.status == 'Sent'
    end
  end
end
