# frozen_string_literal: true

##
require 'rails_helper'

RSpec.describe 'messages/show', type: :view do
  before(:each) do
    @message = assign(:message, Message.create!(
                                  content: 'Content',
                                  status: 'Status'
                                ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Content/)
    expect(rendered).to match(/Status/)
  end
end
