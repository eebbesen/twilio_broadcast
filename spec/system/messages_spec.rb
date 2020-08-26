require 'rails_helper'

RSpec.describe "Messages", type: :system do
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
    text = "This is a test message from #{DateTime.now.strftime('%I:%M:')}"

    visit '/messages'
    click_on 'New Message'

    fill_in 'Content', with: text
    click_on 'Create Message'

    expect(page).to have_text 'Message was successfully created.'
    expect(page).to have_text "Content: #{text}"
  end

  it "doesn't allow message creation with blank content" do

    visit '/messages'
    click_on 'New Message'

    fill_in 'Content', with: ''
    click_on 'Create Message'

    expect(page).to have_text "Content can't be blank"
    expect(page).to have_text 'Content is too short'
  end
end
