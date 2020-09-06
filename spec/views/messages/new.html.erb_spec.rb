# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'messages/new', type: :view do
  before(:each) do
    user = create(:user_1)
    view.stub(:current_user) { user }
    assign(:message, Message.new(
                       content: 'MyString',
                       user_id: user.id
                     ))
  end

  it 'renders new message form' do
    render

    assert_select 'form[action=?][method=?]', messages_path, 'post' do
      assert_select 'input[name=?]', 'message[content]'
    end
  end
end
