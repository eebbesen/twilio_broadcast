# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'recipient_lists/new', type: :view do
  before(:each) do
    user = create(:user_1)
    assign(:recipient_list, RecipientList.new(
                              name: 'MyString',
                              notes: 'MyString',
                              user_id: user.id
                            ))
  end

  it 'renders new recipient_list form' do
    render

    assert_select 'form[action=?][method=?]', recipient_lists_path, 'post' do
      assert_select 'input[name=?]', 'recipient_list[name]'

      assert_select 'input[name=?]', 'recipient_list[notes]'
    end
  end
end
