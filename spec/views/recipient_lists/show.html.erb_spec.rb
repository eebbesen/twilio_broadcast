# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'recipient_lists/show', type: :view do
  before(:each) do
    user = create(:user_1)
    @recipient_list = assign(:recipient_list, RecipientList.create!(
                                                name: 'Name',
                                                notes: 'Notes',
                                                user_id: user.id
                                              ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Notes/)
  end
end
