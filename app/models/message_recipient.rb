# frozen_string_literal: true

## These are only created when a message is sent
class MessageRecipient < ApplicationRecord
  belongs_to :message
  belongs_to :recipient
end
