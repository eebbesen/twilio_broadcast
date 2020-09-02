# frozen_string_literal: true

##
class Recipient < ApplicationRecord
  validates_presence_of :phone
  belongs_to :user
  has_many :recipient_lists
end
