require 'rails_helper'

RSpec.describe "recipients/show", type: :view do
  before(:each) do
    @recipient = assign(:recipient, Recipient.create!(
      phone: "Phone",
      email: "Email",
      name: "Name",
      notes: "Notes"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Notes/)
  end
end
