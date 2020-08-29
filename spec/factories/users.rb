FactoryBot.define do
  factory :user do

    factory :user_1 do
      email { 'user@tb.tb.moc' }
      password  { 'Passw0rd!' }
      password_confirmation  { 'Passw0rd!' }
    end

    factory :user_2 do
      email { 'user2@tb.tb.moc' }
      password  { 'Passw0rd!2' }
      password_confirmation  { 'Passw0rd!2' }
    end
  end
end
