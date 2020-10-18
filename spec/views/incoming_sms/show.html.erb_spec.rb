require 'rails_helper'

RSpec.describe "incoming_sms/show", type: :view do
  before(:each) do
    @incoming_sm = assign(:incoming_sm, IncomingSms.create!(
      phone: "Phone",
      content: "Content",
      request_type: "Request Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/Content/)
    expect(rendered).to match(/Request Type/)
  end
end
