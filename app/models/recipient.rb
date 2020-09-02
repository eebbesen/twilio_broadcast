# frozen_string_literal: true

##
class Recipient < ApplicationRecord
  validates_presence_of :phone
  belongs_to :user
  has_many :recipient_list_members
  has_many :recipient_lists, through: :recipient_list_members
end
