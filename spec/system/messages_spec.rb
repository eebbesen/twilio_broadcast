# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Messages', type: :system do
  before { driven_by(:rack_test) }
  let(:user) { create(:user_1) }

  context 'signed in user' do
    before do
      visit 'users/sign_in'
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'
    end

    it 'allows message creation' do
      rl1 = create(:recipient_list_1, user: user)
      rl2 = create(:recipient_list_2, user: user)
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

    context 'with recipients' do
      let(:rl1) { create(:recipient_list_1, user: user) }
      let(:rl2) { create(:recipient_list_2, user: user) }

      context 'existing message' do
        let(:message) { create(:message, user: user, content: 'hello there') }
        before do
          rl1.recipients << create(:recipient, user: user, phone: '+16515551212')
          message.recipient_lists << rl1
          message.save!
        end

        it 'deletes unsent message from index' do
          expect do
            visit '/messages'
            click_on 'Delete'
            expect(page).to have_text('Message was successfully destroyed')
            expect(page).not_to have_text(message.content)
          end.to change(Message, :count).by(-1)
        end

        it 'deletes unsent message from show' do
          expect do
            visit "/messages/#{message.id}"
            click_on 'Delete'
            expect(page).to have_text('Message was successfully destroyed')
            expect(page).not_to have_text(message.content)
          end.to change(Message, :count).by(-1)
        end

        it "can't delete sent message from index" do
          message.update_attribute(:status, 'Sent')
          visit '/messages'
          expect(page).not_to have_text('Delete')
          expect(page).to have_text(message.content)
        end

        it "can't delete sent message from show" do
          message.update_attribute(:status, 'Sent')
          visit "/messages/#{message.id}"
          expect(page).not_to have_text('Delete')
          expect(page).to have_text(message.content)
        end
      end
    end
  end
end
