# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'recipients/new', type: :view do
  before(:each) do
    user = create(:user_1)
    assign(:recipient, Recipient.new(
                         phone: '0008675309',
                         email: 'recipient@tb.tb.moc',
                         name: 'Omar Jay',
                         notes: 'Registered at Cardy Park 2019',
                         user_id: user.id
                       ))
  end

  it 'renders new recipient form' do
    render

    assert_select 'form[action=?][method=?]', recipients_path, 'post' do
      assert_select 'input[name=?]', 'recipient[phone]'

      assert_select 'input[name=?]', 'recipient[email]'

      assert_select 'input[name=?]', 'recipient[name]'

      assert_select 'input[name=?]', 'recipient[notes]'
    end
  end
end
