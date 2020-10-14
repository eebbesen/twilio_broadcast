# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecipientList, type: :model do
  context '.format_keyword' do
    it 'downcases keyword on save' do
      rl = RecipientList.new(user: create(:user_1), name: 'A list', keyword: 'KeyWord')
      rl.save!
      expect(rl.keyword).to eq('keyword')
    end

    it 'handles lowercase keyword' do
      expect(RecipientList.format_keyword('kw')).to eq('kw')
    end

    it 'handles uppercase keyword' do
      expect(RecipientList.format_keyword('KW')).to eq('kw')
    end

    it 'handles mixed-case keyword' do
      expect(RecipientList.format_keyword('kW')).to eq('kw')
    end

    it "doesn't fail with nil keyword" do
      expect(RecipientList.format_keyword(nil)).to be_nil
    end
  end
end
