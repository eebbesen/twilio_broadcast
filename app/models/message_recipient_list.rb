# frozen_string_literal: true

##
class MessageRecipientList < ApplicationRecord
  belongs_to :message
  belongs_to :recipient_list
end
