# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'recipients/index', type: :view do
  before(:each) do
    user = create(:user_1)
    assign(:recipients, [
             Recipient.create!(
               phone: '0008675309',
               email: 'recipient1@tb.tb.moc',
               name: 'Omar',
               notes: 'Cardy Park 2019',
               user_id: user.id
             ),
             Recipient.create!(
               phone: '0002738255',
               email: 'recipient2@tb.tb.moc',
               name: 'Khalid',
               notes: 'Mekong Night Market 2020',
               user_id: user.id
             )
           ])
  end

  it 'renders a list of recipients' do
    render
    assert_select 'tr>td', text: '0008675309'.to_s
    assert_select 'tr>td', text: 'recipient1@tb.tb.moc'.to_s
    assert_select 'tr>td', text: 'Omar'.to_s
    assert_select 'tr>td', text: 'Cardy Park 2019'.to_s
    assert_select 'tr>td', text: '0002738255'.to_s
    assert_select 'tr>td', text: 'recipient2@tb.tb.moc'.to_s
    assert_select 'tr>td', text: 'Khalid'.to_s
    assert_select 'tr>td', text: 'Mekong Night Market 2020'.to_s
  end
end
