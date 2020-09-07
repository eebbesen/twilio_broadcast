# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do
  it 'validates presence of phone' do
    r = Message.new
    expect(r.valid?).not_to be_truthy
    expect(r.errors[:content]).to include("can't be blank")
  end

  context '#recipient_list_active?' do
    before(:each) do
      @u = create(:user_1)
      @r = create(:recipient_1, user: @u)
      @rl = create(:recipient_list_1, user: @u, recipients: [@r], id: 100)
    end

    it 'is true when associated with list' do
      @m = create(:message_1, user: @u, recipient_lists: [@rl])
      expect(@m.recipient_list_active?(@rl.id)).to be_truthy
    end

    it 'is false when not associated with list' do
      rl_two = create(:recipient_list_2, user: @u, recipients: [@r], id: 1001)
      @m = create(:message_1, user: @u, recipient_lists: [@rl])
      expect(@m.recipient_list_active?(rl_two.id)).to be_falsey
    end
  end

  context '#sent?' do
    it 'returns true if status Sent' do
      m = create(:message_1, user: create(:user_1), status: 'Sent')
      expect(m.sent?).to be_truthy
    end

    it 'returns true if status queued' do
      m = create(:message_1, user: create(:user_1), status: 'queued')
      expect(m.sent?).to be_truthy
    end

    it 'returns false unless status Sent' do
      m = create(:message_1, user: create(:user_1), status: nil)
      expect(m.sent?).to be_falsey

      m.update_attribute(:status, 'New')
      expect(m.sent?).to be_falsey

      m.update_attribute(:status, 'Unsent')
      expect(m.sent?).to be_falsey
    end
  end

  context '#recipients?' do
    before(:each) do
      @u = create(:user_1)
      @r = create(:recipient_1, user: @u)
      @rl = create(:recipient_list_1, user: @u, recipients: [@r], id: 100)
    end

    it 'returns true if any recipients in lists' do
      m = create(:message_1, user: @u, recipient_lists: [@rl])
      expect(m.recipients?).to be_truthy
    end

    it 'returns false if no recipient_lists with recipients' do
      rl = create(:recipient_list_1, user: @u)
      m = create(:message_1, user: @u, recipient_lists: [rl])
      expect(m.recipients?).to be_falsey
    end

    it 'returns false if no recipient_lists' do
      m = create(:message_1, user: @u)
      expect(m.recipients?).to be_falsey
    end
  end
end
