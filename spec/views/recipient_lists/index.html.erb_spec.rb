# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'recipient_lists/index', type: :view do
  before(:each) do
    user = create(:user_1)
    assign(:recipient_lists, [
             RecipientList.create!(
               name: 'Zoning 1',
               notes: 'Notes commercial',
               user_id: user.id
             ),
             RecipientList.create!(
               name: 'Zoning 2',
               notes: 'Zoning residential',
               user_id: user.id
             )
           ])
  end

  it 'renders a list of recipient_lists' do
    render
    assert_select 'tr>td', text: 'Zoning 1'.to_s
    assert_select 'tr>td', text: 'Zoning 2'.to_s
  end
end
