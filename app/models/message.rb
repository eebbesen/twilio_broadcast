# frozen_string_literal: true

##
class Message < ApplicationRecord
  validates :content, presence: true, length: { minimum: 5 }
end
