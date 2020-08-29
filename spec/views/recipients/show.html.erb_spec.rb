# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'recipients/show', type: :view do
  before(:each) do
    user = create(:user_1)
    @recipient = assign(:recipient, Recipient.create!(
                                      phone: '0008675309',
                                      email: 'recipient@tb.tb.moc',
                                      name: 'Omar Jay',
                                      notes: 'Registered at Cardy Park 2019',
                                      user_id: user.id
                                    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Notes/)
  end
end
