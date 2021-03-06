# frozen_string_literal: true

FactoryBot.define do
  factory :recipient do
    factory :recipient_1 do
      phone { '+10008675309' }
      email { 'omar@tb.tb.moc' }
      name { 'Omar' }
      notes  { 'Cardy Park 2019' }
    end

    factory :recipient_2 do
      phone { '+10002738255' }
      email { 'khalid@tb.tb.moc' }
      name { 'Khalid' }
      notes  { 'Mekong Night Market 2020' }
    end
  end
end
