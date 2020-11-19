# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RecipientLists', type: :system do
  before { driven_by(:rack_test) }
  let(:user) { create(:user_1) }

  context 'signed in user' do
    before do
      visit 'users/sign_in'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'
    end

    it 'allows recipient list creation' do
      visit '/recipient_lists'
      click_on 'New Recipient List'

      fill_in 'Name', with: 'Zoning'
      fill_in 'Notes', with: 'Zoning issues'
      fill_in 'Keyword', with: 'ZONING'
      click_on 'Create Recipient list'

      expect(page).to have_text 'Recipient list was successfully created.'
      expect(page).to have_text 'Name: Zoning'
      expect(page).to have_text 'Notes: Zoning issues'
      expect(page).to have_text 'Keyword: zoning'
    end

    context 'existing recipient list' do
      let(:rl1) { create(:recipient_list_1, user: user) }
      before do
        rl2 = create(:recipient_list_2, user: user)
        create(:recipient_1, recipient_lists: [rl1, rl2], user: user)
      end

      it 'allows recipient list deletion from show' do
        visit "/recipient_lists/#{rl1.id}"

        expect do
          find('.btn-danger', match: :first).click
          expect(page).to have_text 'Recipient list was successfully deleted.'
        end.to change(RecipientList, :count).by(-1)
      end

      it 'allows recipient list deletion from index' do
        visit '/recipient_lists'

        expect do
          find('.btn-danger', match: :first).click
          expect(page).to have_text 'Recipient list was successfully deleted.'
        end.to change(RecipientList, :count).by(-1)
      end

      it 'allows recipient list edit' do
        visit "/recipient_lists/#{rl1.id}"
        click_on 'Edit'

        fill_in 'Name', with: 'updated list name'
        click_on 'Update Recipient list'

        expect(page).to have_text 'Recipient list was successfully updated.'
        expect(page).to have_text 'Name: updated list name'
        expect(page).to have_text "Notes: #{rl1.notes}"
      end
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
