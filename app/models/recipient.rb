# frozen_string_literal: true

##
class Recipient < ApplicationRecord
  validates_presence_of :phone
  belongs_to :user
end
