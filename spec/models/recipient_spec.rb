# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Recipient, type: :model do
  context 'scopes' do
    it "doesn't returned removed recipients" do
      user = create(:user_1)
      create(:recipient, phone: '+1001112222', user: user)
      create(:recipient, phone: '+1001113333', removed: true, user: user)

      expect(Recipient.available.count).to eq(1)
    end
  end

  context '.normalize_phone' do
    it "doesn't change E.164-formatted number" do
      expect(Recipient.normalize_phone('+16515551212')).to eq('+16515551212')
    end

    it 'adds "+" to a number with the country code' do
      expect(Recipient.normalize_phone('16515551212')).to eq('+16515551212')
    end

    it 'adds "+1" to a number without the country code' do
      expect(Recipient.normalize_phone('6515551212')).to eq('+16515551212')
    end

    it 'normalizes phone before save' do
      r = Recipient.new(user: create(:user_1), phone: '6515551212')
      r.save!
      expect(r.phone).to eq('+16515551212')
    end
  end

  it 'validates presence of phone' do
    r = Recipient.new(email: 'user@td.td.com')
    expect(r.valid?).not_to be_truthy
    expect(r.errors[:phone]).to include("can't be blank")
  end

  it 'validates presence of phone nil' do
    r = Recipient.new(email: 'user@td.td.com', phone: nil)
    expect(r.valid?).not_to be_truthy
    expect(r.errors[:phone]).to include("can't be blank")
  end

  context 'recipient lists' do
    before(:each) do
      @u = create(:user_1)
      @r = create(:recipient_1, user: @u)
      @rl = create(:recipient_list_1, user: @u, recipients: [@r], id: 100)
    end

    context '#on_recipient_list?' do
      it 'is true when associated with list' do
        @r = create(:recipient_1, user: @u, recipient_lists: [@rl])
        expect(@r.on_recipient_list?(@rl.id)).to be_truthy
      end

      it 'is false when not associated with list' do
        rl_two = create(:recipient_list_2, user: @u, recipients: [@r], id: 1001)
        @r = create(:recipient_1, user: @u, recipient_lists: [@rl])
        expect(@r.on_recipient_list?(rl_two.id)).to be_falsey
      end
    end

    it 'deletes associated recipient_list_members' do
      @rlc = @r.recipient_list_members.count
      expect(@rlc).to be > 0

      expect do
        expect do
          @r.remove
        end.to change(Recipient, :count).by(-1)
      end.to change(RecipientListMember, :count).by(@rlc * -1)
    end
  end
end
