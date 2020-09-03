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
end
