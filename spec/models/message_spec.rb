# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do
  it 'validates presence of phone' do
    r = Message.new
    expect(r.valid?).not_to be_truthy
    expect(r.errors[:content]).to include("can't be blank")
  end
end
