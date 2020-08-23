# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'recipients/edit', type: :view do
  before(:each) do
    @recipient = assign(:recipient, Recipient.create!(
                                      phone: 'MyString',
                                      email: 'MyString',
                                      name: 'MyString',
                                      notes: 'MyString'
                                    ))
  end

  it 'renders the edit recipient form' do
    render

    assert_select 'form[action=?][method=?]', recipient_path(@recipient), 'post' do
      assert_select 'input[name=?]', 'recipient[phone]'

      assert_select 'input[name=?]', 'recipient[email]'

      assert_select 'input[name=?]', 'recipient[name]'

      assert_select 'input[name=?]', 'recipient[notes]'
    end
  end
end
