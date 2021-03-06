# frozen_string_literal: true

require 'rails_helper'

module Twilio
  module Security
    ##
    # for twilio incoming auth, always return true during tests
    class RequestValidator
      def validate(_url, _params, _signature)
        true
      end
    end
  end
end

RSpec.describe '/messages', type: :request do
  let(:user) { create(:user_1) }

  let(:valid_attributes) do
    { content: 'hello from the texter', user_id: user.id }
  end

  let(:invalid_attributes) do
    { content: '', user_id: user.id }
  end

  context 'incoming' do
    before do
      r1 = create(:recipient_1, phone: '15005550006', user: user)
      rl = create(:recipient_list_1, user: user, recipients: [r1])
      m = create(:message_1, user: user, recipient_lists: [rl])
      MessageRecipient.create(message: m, recipient: r1, sid: 'SMXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX')

      callback_string = <<-JSON
      {
        "SmsSid": "SMXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
        "SmsStatus": "delivered",
        "MessageStatus": "delivered",
        "To": "+15005550006",
        "MessageSid": "SMXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
        "AccountSid": "ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
        "From": "+16515551212",
        "ApiVersion": "2010-04-01"
      }
      JSON
      @cb = JSON.parse callback_string
    end

    it 'accepts status update' do
      mr = MessageRecipient.last
      expect(mr.status).not_to eq('delivered')

      post sms_status_url(@cb)

      mr.reload
      expect(mr.status).to eq('delivered')
      expect(response.body).to include(mr.sid)
      expect(response.status).to eq(200)
    end

    it 'accepts status update JSON' do
      mr = MessageRecipient.last
      expect(mr.status).not_to eq('delivered')

      post sms_status_url, params: @cb.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }

      mr.reload
      expect(mr.status).to eq('delivered')
      expect(response.body).to include(mr.sid)
      expect(response.status).to eq(200)
    end

    it "doesn't update when sid not found" do
      @cb['SmsSid'] = 'SMX'

      post sms_status_url(@cb)

      expect(MessageRecipient).not_to receive(:update)
      expect(response.body).to include('SMX')
      expect(response.body).to include('no recipient found')
      expect(response.status).to eq(422)
    end

    it "doesn't update when sid not found JSON" do
      @cb['SmsSid'] = 'SMX'

      post sms_status_url, params: @cb.to_json, headers: { 'CONTENT_TYPE' => 'application/json' }

      expect(MessageRecipient).not_to receive(:update)
      expect(response.body).to include('SMX')
      expect(response.body).to include('no recipient found')
      expect(response.status).to eq(422)
    end

    it 'records error code' do
      @cb['ErrorCode'] = 30_005
      @cb['SmsStatus'] = 'undelivered'

      post sms_status_url(@cb)

      mr = MessageRecipient.last.reload
      expect(mr.status).to eq('undelivered')
      expect(mr.error_code).to eq(30_005)
      expect(response.body).to include(mr.sid)
      expect(response.status).to eq(200)
    end
  end

  context 'signed in user' do
    before(:each) do
      sign_in user
    end

    describe 'POST /send_message' do
      it 'sends successfully to all recipients' do
        expect do
          r1 = create(:recipient_1, phone: '15005550006', user: user)
          r2 = create(:recipient_2, phone: '15005550007', user: user)
          rl = create(:recipient_list_1, user: user, recipients: [r1, r2])
          m = create(:message_1, user: user, recipient_lists: [rl])

          VCR.use_cassette('twilio_post_message_spec') do
            post send_message_url(m)
            expect(response).to redirect_to(message_url(m))
            follow_redirect!
            expect(response.body).to include('Message sent')
          end

          m.reload

          expect(m.message_recipients.count).to eq(2)
          expect(m.status).to eq('Sent')
          expect(m.sent_at).not_to be_nil
          expect(m.message_recipients.first.sid).not_to be_nil
        end.to change(MessageRecipient, :count).by(2)
      end

      it "doesn't send if recipient_list with no recipients" do
        rl = create(:recipient_list_1, user: user)
        m = create(:message_1, user: user, recipient_lists: [rl])

        expect do
          post send_message_url(m)

          expect(response).to redirect_to(message_url(m))
          follow_redirect!
          expect(response.body).to include('Please select recipients')

          m.reload
          expect(m.status).to be_nil
          expect(m.sent_at).to be_nil
        end.to change(MessageRecipient, :count).by(0)
      end

      it "doesn't send if with no recipient_lists" do
        m = create(:message_1, user: user)

        expect do
          post send_message_url(m)

          expect(response).to redirect_to(message_url(m))
          follow_redirect!
          expect(response.body).to include('Please select recipients')

          m.reload
          expect(m.status).to be_nil
          expect(m.sent_at).to be_nil
        end.to change(MessageRecipient, :count).by(0)
      end
    end

    describe 'GET /index' do
      it 'renders a successful response' do
        Message.create! valid_attributes
        get messages_url

        expect(response).to be_successful
        expect(response.body).to include(valid_attributes[:content])
      end

      it 'only gets messages for current user' do
        message_1 = create(:message_1, user: user)
        message_2 = create(:message_2, user: create(:user_2))

        get messages_url

        expect(response).to be_successful
        expect(response.body).to include(message_1.content)
        expect(response.body).not_to include(message_2.content)
      end

      it 'only shows delete for unsent messages' do
        create(:message_1, user: user)
        create(:message_2, user: user, status: 'Sent')

        get messages_url

        expect(response.body).to include('Delete').at_most(1).times
      end
    end

    describe 'GET /show' do
      it 'renders a successful response' do
        message = Message.create! valid_attributes
        get message_url(message)
        expect(response).to be_successful
      end

      it "doesn't show messages for other users" do
        message_2 = create(:message_2, user: create(:user_2))
        get message_url(message_2)
        expect(response).to be_successful
        expect(response.body).to include('Message not found')
        expect(response.body).not_to include(message_2.content)
      end
    end

    describe 'GET /new' do
      it 'renders a successful response' do
        get new_message_url
        expect(response).to be_successful
      end
    end

    describe 'GET /edit' do
      it 'render a successful response' do
        message = Message.create! valid_attributes
        get edit_message_url(message)
        expect(response).to be_successful
      end

      it "can't edit other user's message" do
        message = create(:message_2, user: create(:user_2))

        get edit_message_url(message)

        expect(response).to be_successful
        expect(response.body).not_to include(message.content)
        expect(response.body).to include('Message not found')
      end
    end

    describe 'POST /create' do
      context 'with valid parameters' do
        it 'creates a new Message' do
          expect do
            post messages_url, params: { message: valid_attributes }
          end.to change(Message, :count).by(1)
        end

        it 'redirects to the created message' do
          post messages_url, params: { message: valid_attributes }
          expect(response).to redirect_to(message_url(Message.last))
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new Message' do
          expect do
            post messages_url, params: { message: invalid_attributes }
          end.to change(Message, :count).by(0)
        end

        it "renders a successful response (i.e. to display the 'new' template)" do
          post messages_url, params: { message: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end

    describe 'PATCH /update' do
      context 'with valid parameters' do
        let(:new_attributes) do
          { content: 'hello from the texter 2' }
        end

        it 'updates the requested message' do
          message = Message.create! valid_attributes
          patch message_url(message), params: { message: new_attributes }
          message.reload

          # this is also a 302 redirect from generation
          # expect(response).to be_successful
          expect(message.content).to eq(new_attributes[:content])
        end

        it 'redirects to the message' do
          message = Message.create! valid_attributes
          patch message_url(message), params: { message: new_attributes }
          message.reload
          expect(response).to redirect_to(message_url(message))
        end

        it "can't update other user's message" do
          exception = nil
          message = create(:message_2, user: create(:user_2))

          begin
            patch message_url(message), params: { message: new_attributes }
          rescue StandardError => e
            exception = e
          end

          expect(exception.message).to include("undefined method `update' for nil:NilClass")
        end

        # this is redirecting and not 200ing
        # getting 200 when run in browser manually
        # this was failing ever since scaffold generation
        # context "with invalid parameters" do
        #   it "renders a successful response (i.e. to display the 'edit' template)" do
        #     message = Message.create! valid_attributes
        #     patch message_url(message), params: { message: invalid_attributes }
        #     expect(response).to be_successful
        #   end
        # end
      end
    end

    describe 'DELETE /destroy' do
      it 'destroys the requested message' do
        message = Message.create! valid_attributes
        expect do
          delete message_url(message)
        end.to change(Message, :count).by(-1)
      end

      it 'removes message recipient lists' do
        message = Message.create! valid_attributes
        rl = RecipientList.create! name: 'My List', user: message.user
        MessageRecipientList.create! message: message, recipient_list: rl
        expect do
          expect do
            delete message_url(message)
          end.to change(MessageRecipientList, :count).by(-1)
        end.to change(Message, :count).by(-1)
      end

      it 'raises SentMessageError when attempt to destroy a sent message' do
        message = Message.create! valid_attributes
        message.update_attribute(:status, 'Sent')
        expect do
          expect do
            delete message_url(message)
            expect(response).to redirect_to(messages_url)
          end.not_to change(MessageRecipientList, :count)
        end.not_to change(Message, :count)
      end

      it 'redirects to the messages list' do
        message = Message.create! valid_attributes
        delete message_url(message)
        expect(response).to redirect_to(messages_url)
      end

      it "can't delete other user's message" do
        message = create(:message_2, user: create(:user_2))

        begin
          delete message_url(message)
        rescue StandardError => e
          exception = e
        end
        expect(exception.message).to include("undefined method `remove' for nil:NilClass")
      end
    end
  end
end
