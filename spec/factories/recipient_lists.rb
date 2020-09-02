# frozen_string_literal: true

FactoryBot.define do
  factory :recipient_list do
    factory :recipient_list_1 do
      name { 'Zoning' }
      notes { 'residential and commercial zoning' }
    end

    factory :recipient_list_2 do
      name { 'Commnity events' }
      notes { 'events in the neighborhood' }
    end
  end
end
