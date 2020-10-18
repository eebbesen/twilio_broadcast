require 'rails_helper'

RSpec.describe "incoming_sms/index", type: :view do
  before(:each) do
    assign(:incoming_sms, [
      IncomingSms.create!(
        phone: "Phone",
        content: "Content",
        request_type: "Request Type"
      ),
      IncomingSms.create!(
        phone: "Phone",
        content: "Content",
        request_type: "Request Type"
      )
    ])
  end

  it "renders a list of incoming_sms" do
    render
    assert_select "tr>td", text: "Phone".to_s, count: 2
    assert_select "tr>td", text: "Content".to_s, count: 2
    assert_select "tr>td", text: "Request Type".to_s, count: 2
  end
end
