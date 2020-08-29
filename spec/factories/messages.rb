# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    factory :message_1 do
      content { 'My first text message' }
    end

    factory :message_2 do
      content { 'User 2 first text message' }
    end
  end
end
