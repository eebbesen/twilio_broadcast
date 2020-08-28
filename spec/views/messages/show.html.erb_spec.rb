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
end
