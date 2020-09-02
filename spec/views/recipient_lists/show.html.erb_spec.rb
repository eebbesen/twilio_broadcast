# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'recipient_lists/show', type: :view do
  before(:each) do
    user = create(:user_1)
    recipient = create(:recipient_1, user: user)
    @recipient_list = assign(:recipient_list, RecipientList.create!(
                                                name: 'Zoning',
                                                notes: 'Notes',
                                                user_id: user.id
                                              ))
    create(:recipient_list_member, recipient: recipient, recipient_list: @recipient_list)
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Zoning/)
    expect(rendered).to match(/Notes/)
  end

  it 'renders list members' do
    render
    expect(rendered).to match(/Members/)
    expect(rendered).to match(/Omar/)
    expect(rendered).to match(/0008675309/)
    expect(rendered).to match(/omar@tb.tb.moc/)
  end
end
