# frozen_string_literal: true

##
require 'rails_helper'

RSpec.describe 'messages/index', type: :view do
  before(:each) do
    assign(:messages, [
             Message.create!(
               content: 'Content',
               status: 'Status'
             ),
             Message.create!(
               content: 'Content',
               status: 'Status'
             )
           ])
  end

  it 'renders a list of messages' do
    render
    assert_select 'tr>td', text: 'Content'.to_s, count: 2
    assert_select 'tr>td', text: 'Status'.to_s, count: 2
  end
end
