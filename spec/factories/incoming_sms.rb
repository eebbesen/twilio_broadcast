# frozen_string_literal: true

FactoryBot.define do
  factory :incoming_sms do
    phone { 'MyString' }
    content { 'MyString' }
    request_type { 'MyString' }
  end
end
