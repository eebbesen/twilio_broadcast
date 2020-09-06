# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'messages/new', type: :view do
  before(:each) do
    user = create(:user_1)
    allow(view).to receive(:current_user).and_return(user)
    assign(:message, Message.new(
                       content: 'MyString',
                       user_id: user.id
                     ))
  end

  it 'renders new message form' do
    render

    assert_select 'form[action=?][method=?]', messages_path, 'post' do
      assert_select '#message_content', 'MyString'
    end
  end
end
