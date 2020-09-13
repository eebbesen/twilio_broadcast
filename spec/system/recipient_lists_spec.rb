# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RecipientLists', type: :system do
  before do
    driven_by(:rack_test)
  end

  context 'signed in user' do
    before do
      @user = create(:user_1)
      visit 'users/sign_in'
      fill_in 'Email', with: @user.email
      fill_in 'Password', with: @user.password
      click_on 'Log in'
    end

    it 'allows recipient list creation' do
      visit '/recipient_lists'
      click_on 'New Recipient List'

      fill_in 'Name', with: 'Zoning'
      fill_in 'Notes', with: 'Zoning issues'
      click_on 'Create Recipient list'

      expect(page).to have_text 'Recipient list was successfully created.'
      expect(page).to have_text 'Name: Zoning'
      expect(page).to have_text 'Notes: Zoning issues'
    end

    it 'allows recipient list edit' do
      rl1 = create(:recipient_list_1, user: @user)
      rl2 = create(:recipient_list_2, user: @user)
      rec = create(:recipient_1, recipient_lists: [rl1, rl2], user: @user)

      visit "/recipient_lists/#{rl1.id}"
      click_on 'Edit'

      fill_in 'Name', with: 'updated list name'
      click_on 'Update Recipient list'

      expect(page).to have_text 'Recipient list was successfully updated.'
      expect(page).to have_text 'Name: updated list name'
      expect(page).to have_text "Notes: #{rl1.notes}"
    end

    it "doesn't allow recipient creation with blank name" do
      visit '/recipient_lists'
      click_on 'New Recipient List'

      fill_in 'Notes', with: 'Zoning stuff'
      click_on 'Create Recipient list'

      expect(page).to have_text "Name can't be blank"
    end
  end
end
