# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Recipients', type: :system do
  before do
    driven_by(:rack_test)

    pword = 'Passw0rd!'
    User.create(email: 'user@tb.tb.moc', password: pword, password_confirmation: pword)

    visit 'users/sign_in'
    fill_in 'Email', with: 'user@tb.tb.moc'
    fill_in 'Password', with: pword
    click_on 'Log in'
  end

  it 'allows message creation' do
    visit '/recipients'
    click_on 'New Recipient'

    fill_in 'Phone', with: '6515551212'
    fill_in 'Email', with: 'recipient@td.td.com'
    fill_in 'Name', with: 'Omar Recipient'
    fill_in 'Notes', with: 'Registered at Mekong Night Market 2019'
    click_on 'Create Recipient'

    expect(page).to have_text 'Recipient was successfully created.'
    expect(page).to have_text 'Phone: 6515551212'
    expect(page).to have_text 'Email: recipient@td.td.com'
    expect(page).to have_text 'Name: Omar Recipient'
    expect(page).to have_text 'Notes: Registered at Mekong Night Market 2019'
  end

  it "doesn't allow message creation with blank phone" do
    visit '/recipients'
    click_on 'New Recipient'

    fill_in 'Email', with: 'recipient@td.td.com'
    fill_in 'Name', with: 'Omar Recipient'
    fill_in 'Notes', with: 'Registered at Mekong Night Market 2019'
    click_on 'Create Recipient'

    expect(page).to have_text "Phone can't be blank"
  end
end