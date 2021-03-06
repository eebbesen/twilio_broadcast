# frozen_string_literal: true

## devise user
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  has_many :messages
  has_many :recipients
  has_many :recipient_lists
  has_many :recipient_list_members
end
