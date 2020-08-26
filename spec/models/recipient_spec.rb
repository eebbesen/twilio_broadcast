# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Recipient, type: :model do
  it 'validates presence of phone' do
    r = Recipient.new(email: 'user@td.td.com')
    expect(r.valid?).not_to be_truthy
    expect(r.errors[:phone]).to include("can't be blank")
  end
end
