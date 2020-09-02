# frozen_string_literal: true

##
class RecipientList < ApplicationRecord
  validates_presence_of :name
  belongs_to :user
  has_many :recipient_list_members
  has_many :recipients, through: :recipient_list_members
end
