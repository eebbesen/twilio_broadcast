# frozen_string_literal: true

FactoryBot.define do
  factory :recipient_list_member do
    factory :rlm_one do
      recipient { recipient_1 }
      recipient_list { recipient_list_1 }
    end
  end
end
