# frozen_string_literal: true

##
require 'rails_helper'

RSpec.describe 'messages/index', type: :view do
  before(:each) do
    user = create(:user_1)
    assign(:messages, [
             Message.create!(
               content: 'Content 1',
               user_id: user.id
             ),
             Message.create!(
               content: 'Content 2',
               user_id: user.id
             )
           ])
  end

  it 'renders a list of messages' do
    render
    assert_select 'tr>td', text: 'Content 1'.to_s
    assert_select 'tr>td', text: 'Content 2'.to_s
  end
end
