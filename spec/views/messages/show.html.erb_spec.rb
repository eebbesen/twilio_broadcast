# frozen_string_literal: true

##
require 'rails_helper'

RSpec.describe 'messages/show', type: :view do
  before(:each) do
    user = create(:user_1)
    @message = assign(:message, Message.create!(
                                  content: 'Content',
                                  user_id: user.id
                                ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Content/)
  end

  it 'shows message when user attempts to access another user\'s message or message doesn\'t exist' do
    @message = assign(:message, nil)
    render
    expect(rendered).to match(/Message not found/)
  end
end
