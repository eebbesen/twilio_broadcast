# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'messages/edit', type: :view do
  before(:each) do
    user = create(:user_1)
    view.stub(:current_user) { user }
    @message = assign(:message, Message.create!(
                                  content: 'MyString',
                                  user_id: user.id
                                ))
  end

  it 'renders the edit message form' do
    render

    assert_select 'form[action=?][method=?]', message_path(@message), 'post' do
      assert_select 'input[name=?]', 'message[content]'
    end
  end
end
