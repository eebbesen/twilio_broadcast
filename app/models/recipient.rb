# frozen_string_literal: true

##
class Recipient < ApplicationRecord
  validates_presence_of :phone
end
