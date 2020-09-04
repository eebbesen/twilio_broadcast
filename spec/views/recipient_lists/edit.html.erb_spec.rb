# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'recipient_lists/edit', type: :view do
  before(:each) do
    user = create(:user_1)
    @recipient_list = assign(:recipient_list, RecipientList.create!(
                                                name: 'Zoning',
                                                notes: 'Interested in Zoning updates',
                                                user_id: user.id
                                              ))
  end

  it 'renders the edit recipient_list form' do
    render

    assert_select 'form[action=?][method=?]', recipient_list_path(@recipient_list), 'post' do
      assert_select 'input[name=?]', 'recipient_list[name]'

      assert_select 'input[name=?]', 'recipient_list[notes]'
    end
  end
end
