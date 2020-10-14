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

RSpec.describe '/recipient_lists', type: :request do
  let(:user) { create(:user_1) }

  let(:valid_attributes) do
    { name: 'Zoning Changes', user_id: user.id, keyword: 'kw', notes: 'description of list' }
  end

  let(:invalid_attributes) do
    { user_id: user.id }
  end

  context 'subscribe' do
    before(:each) { @rl = RecipientList.create! valid_attributes }
    describe 'POST /subscribe' do
      it 'creates new recipient and recipient_list_member' do
        expect do
          expect do
            post subscribe_url({ body: 'KW', phone: '7635551212' })
            expect(response).to be_successful
          end.to change(RecipientListMember, :count).by(1)
        end.to change(Recipient, :count).by(1)
      end

      it 'updates existing recipient and creates new recipient_list_member' do
        Recipient.create!({ phone: '7635551212', user: user })
        expect do
          expect do
            post subscribe_url({ body: 'kW', phone: '+17635551212' })
            expect(response).to be_successful
          end.to change(RecipientListMember, :count).by(1)
        end.to change(Recipient, :count).by(0)
      end

      it 'does nothing when recipient already subscribed' do
        r = Recipient.create!({ phone: '7635551212', user: user })
        RecipientListMember.create!({ recipient: r, recipient_list: @rl })
        expect do
          expect do
            post subscribe_url({ body: 'KW', phone: '+17635551212' })
            expect(response).to be_successful
          end.to change(RecipientListMember, :count).by(0)
        end.to change(Recipient, :count).by(0)
      end

      it 'returns unsuccessful when keyword does not match' do
        expect do
          expect do
            post subscribe_url({ body: 'BK', phone: '+17635551212' })
            expect(response.status).to eq(422)
            expect(response.body).to include('could not persist subscription for +17635551212 to list BK')
          end.to change(RecipientListMember, :count).by(0)
        end.to change(Recipient, :count).by(0)
      end
    end
  end

  context 'signed in user' do
    before(:each) do
      sign_in user
    end
    describe 'GET /index' do
      it 'renders a successful response' do
        RecipientList.create! valid_attributes
        get recipient_lists_url
        expect(response).to be_successful
      end

      it 'only gets recipient list for current user' do
        recipient_list_1 = create(:recipient_list_1, user: user)
        recipient_list_2 = create(:recipient_list_2, user: create(:user_2))

        get recipient_lists_url

        expect(response).to be_successful
        expect(response.body).to include(recipient_list_1.name)
        expect(response.body).not_to include(recipient_list_2.name)
      end
    end

    describe 'GET /show' do
      it 'renders a successful response' do
        recipient_list = RecipientList.create! valid_attributes
        get recipient_list_url(recipient_list)
        expect(response).to be_successful
      end

      it "doesn't show recipient lists for other users" do
        recipient_list_2 = create(:recipient_list_2, user: create(:user_2))

        get recipient_list_url(recipient_list_2)

        expect(response).to be_successful
        expect(response.body).to include('Recipient list not found')
        expect(response.body).not_to include(recipient_list_2.name)
      end
    end

    describe 'GET /new' do
      it 'renders a successful response' do
        get new_recipient_list_url
        expect(response).to be_successful
      end
    end

    describe 'GET /edit' do
      it 'render a successful response' do
        recipient_list = RecipientList.create! valid_attributes
        get edit_recipient_list_url(recipient_list)
        expect(response).to be_successful
      end

      it "can't edit another user's recipient list" do
        recipient_list = create(:recipient_list_2, user: create(:user_2))

        get edit_recipient_list_url(recipient_list)

        expect(response).to be_successful
        expect(response.body).not_to include(recipient_list.name)
        expect(response.body).to include('Recipient list not found')
      end
    end

    describe 'POST /create' do
      context 'with valid parameters' do
        it 'creates a new RecipientList' do
          expect do
            post recipient_lists_url, params: { recipient_list: valid_attributes }

            rl = RecipientList.last
            expect(rl.keyword).to eq('kw')
            expect(rl.notes).to eq('description of list')
            expect(rl.name).to eq('Zoning Changes')
          end.to change(RecipientList, :count).by(1)
        end

        it 'uses current_user user_id and not user_id parameter passed in' do
          user2 = create(:user_2)
          expect do
            post recipient_lists_url, params: { recipient_list: { name: 'Zoning Changes', user_id: user2.id } }
          end.to change(RecipientList, :count).by(1)
          expect(RecipientList.last.name).to eq('Zoning Changes')
          expect(RecipientList.last.user_id).to eq(user.id)
        end

        it 'redirects to the created recipient_list' do
          post recipient_lists_url, params: { recipient_list: valid_attributes }
          expect(response).to redirect_to(recipient_list_url(RecipientList.last))
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new RecipientList' do
          expect do
            post recipient_lists_url, params: { recipient_list: invalid_attributes }
          end.to change(RecipientList, :count).by(0)
        end

        it "renders a successful response (i.e. to display the 'new' template)" do
          post recipient_lists_url, params: { recipient_list: invalid_attributes }
          expect(response).to be_successful
        end
      end
    end

    describe 'PATCH /update' do
      context 'with valid parameters' do
        let(:new_attributes) do
          { name: 'Assessments', user_id: user.id, keyword: 'updated' }
        end

        it 'updates the requested recipient_list' do
          recipient_list = RecipientList.create! valid_attributes
          patch recipient_list_url(recipient_list), params: { recipient_list: new_attributes }
          recipient_list.reload
          expect(recipient_list.name).to eq('Assessments')
          expect(recipient_list.keyword).to eq('updated')
        end

        it 'redirects to the recipient_list' do
          recipient_list = RecipientList.create! valid_attributes
          patch recipient_list_url(recipient_list), params: { recipient_list: new_attributes }
          recipient_list.reload
          expect(response).to redirect_to(recipient_list_url(recipient_list))
        end

        it "can't update other user's recipient list" do
          exception = nil
          recipient_list = create(:recipient_list_2, user: create(:user_2))

          begin
            patch recipient_list_url(recipient_list), params: { recipient_list: new_attributes }
          rescue StandardError => e
            exception = e
          end

          expect(exception.message).to include("undefined method `update' for nil:NilClass")
        end
      end

      context 'with invalid parameters' do
        it "renders a successful response (i.e. to display the 'edit' template)" do
          recipient_list = RecipientList.create! valid_attributes
          patch recipient_list_url(recipient_list), params: { recipient_list: invalid_attributes }
          expect(response).not_to be_successful
        end
      end
    end

    describe 'DELETE /destroy' do
      it 'destroys the requested recipient_list' do
        recipient_list = RecipientList.create! valid_attributes
        expect do
          delete recipient_list_url(recipient_list)
        end.to change(RecipientList, :count).by(-1)
      end

      it 'redirects to the recipient_lists list' do
        recipient_list = RecipientList.create! valid_attributes
        delete recipient_list_url(recipient_list)
        expect(response).to redirect_to(recipient_lists_url)
      end

      it "can't delete other user's recipient" do
        recipient_list = create(:recipient_list_2, user: create(:user_2))

        begin
          delete recipient_list_url(recipient_list)
        rescue StandardError => e
          exception = e
        end
        expect(exception.message).to include("undefined method `destroy' for nil:NilClass")
      end
    end
  end
end
