# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Messages', type: :system do
  before do
    driven_by(:rack_test)
  end

  context 'signed in user' do
    before do
      @user = create(:user_1)
      pword = 'Passw0rd!'
      visit 'users/sign_in'
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: pword
      click_on 'Log in'
    end

    it 'allows message creation' do
      rl1 = create(:recipient_list_1, user: @user)
      rl2 = create(:recipient_list_2, user: @user)

      text = "This is a test message from #{DateTime.now.strftime('%I:%M:')}"

      visit '/messages'
      click_on 'New Message'

      fill_in 'Content', with: text
      page.find("#message_recipient_list_ids_#{rl1.id}").check
      click_on 'Create Message'

      expect(page).to have_text 'Message was successfully created.'
      expect(page).to have_text "Content: #{text}"
      expect(page).to have_text rl1.name
      expect(page).to have_text rl2.name
      expect(page.find("#check_#{rl1.id}").disabled?).to be_truthy
      expect(page.find("#check_#{rl1.id}").checked?).to be_truthy
      expect(page.find("#check_#{rl2.id}").disabled?).to be_truthy
      expect(page.find("#check_#{rl2.id}").checked?).to be_falsey
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
end
