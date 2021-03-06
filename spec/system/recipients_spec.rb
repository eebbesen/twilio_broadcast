# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Recipients', type: :system do
  before { driven_by(:rack_test) }
  let(:user) { create(:user_1) }

  context 'signed in user' do
    before do
      visit 'users/sign_in'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'
    end

    let!(:rl1) { create(:recipient_list_1, user: user) }
    let!(:rl2) { create(:recipient_list_2, user: user) }
    let!(:rec) { create(:recipient_1, recipient_lists: [rl1, rl2], user: user) }

    it 'allows recipient creation' do
      visit '/recipients'
      click_on 'New Recipient'

      fill_in 'Phone', with: '6515551212'
      fill_in 'Email', with: 'recipient@td.td.com'
      fill_in 'Name', with: 'Omar Recipient'
      fill_in 'Notes', with: 'Registered at Mekong Night Market 2019'
      page.find("#recipient_recipient_list_ids_#{rl1.id}").check
      click_on 'Create Recipient'

      expect(page).to have_text 'Recipient was successfully created.'
      expect(page).to have_text 'Phone: +16515551212'
      expect(page).to have_text 'Email: recipient@td.td.com'
      expect(page).to have_text 'Name: Omar Recipient'
      expect(page).to have_text 'Notes: Registered at Mekong Night Market 2019'
      expect(page.find("#check_#{rl1.id}").disabled?).to be_truthy
      expect(page.find("#check_#{rl1.id}").checked?).to be_truthy
      expect(page.find("#check_#{rl2.id}").disabled?).to be_truthy
      expect(page.find("#check_#{rl2.id}").checked?).to be_falsey
    end

    it 'allows recipient deletion from index' do
      visit '/recipients'

      expect do
        click_on 'Delete'
      end.to change(Recipient, :count).by(-1)
    end

    it 'allows recipient deletion from show' do
      visit "/recipients/#{rec.id}"

      expect do
        click_on 'Delete'
      end.to change(Recipient, :count).by(-1)
    end

    it 'allows recipient edit' do
      rec = create(:recipient_1, recipient_lists: [rl1, rl2], user: user)

      visit "/recipients/#{rec.id}"
      click_on 'Edit'

      fill_in 'Name', with: 'Omar Recipient 88'
      fill_in 'Notes', with: 'Registered at Mekong Night Market 2019'
      page.find("#recipient_recipient_list_ids_#{rl1.id}").uncheck
      click_on 'Update Recipient'

      expect(page).to have_text 'Recipient was successfully updated.'
      expect(page).to have_text "Phone: #{rec.phone}"
      expect(page).to have_text "Email: #{rec.email}"
      expect(page).to have_text 'Name: Omar Recipient 88'
      expect(page).to have_text 'Notes: Registered at Mekong Night Market 2019'
      expect(page.find("#check_#{rl1.id}").disabled?).to be_truthy
      expect(page.find("#check_#{rl1.id}").checked?).to be_falsey
      expect(page.find("#check_#{rl2.id}").disabled?).to be_truthy
      expect(page.find("#check_#{rl2.id}").checked?).to be_truthy
    end

    it "doesn't allow recipient creation with blank phone" do
      visit '/recipients'
      click_on 'New Recipient'

      fill_in 'Email', with: 'recipient@td.td.com'
      fill_in 'Name', with: 'Omar Recipient'
      fill_in 'Notes', with: 'Registered at Mekong Night Market 2019'
      click_on 'Create Recipient'

      expect(page).to have_text "Phone can't be blank"
    end
  end
end
