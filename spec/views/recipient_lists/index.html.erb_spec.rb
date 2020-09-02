# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'recipient_lists/index', type: :view do
  before(:each) do
    user = create(:user_1)
    assign(:recipient_lists, [
             RecipientList.create!(
               name: 'Name',
               notes: 'Notes',
               user_id: user.id
             ),
             RecipientList.create!(
               name: 'Name',
               notes: 'Notes',
               user_id: user.id
             )
           ])
  end

  it 'renders a list of recipient_lists' do
    render
    assert_select 'tr>td', text: 'Name'.to_s, count: 2
    assert_select 'tr>td', text: 'Notes'.to_s, count: 2
  end
end
