# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'messages/edit', type: :view do
  before(:each) do
    user = create(:user_1)
    allow(view).to receive(:current_user).and_return(user)
    @message = assign(:message, Message.create!(
                                  content: 'MyString',
                                  user_id: user.id
                                ))
  end

  it 'renders the edit message form' do
    render

    assert_select 'form[action=?][method=?]', message_path(@message), 'post' do
      assert_select '#message_content', 'MyString'
    end
  end
end
