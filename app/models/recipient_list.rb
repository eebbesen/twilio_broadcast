# frozen_string_literal: true

##
class RecipientList < ApplicationRecord
  validates_presence_of :name
  belongs_to :user
  has_many :recipients
end
