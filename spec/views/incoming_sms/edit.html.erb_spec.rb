require 'rails_helper'

RSpec.describe "incoming_sms/edit", type: :view do
  before(:each) do
    @incoming_sm = assign(:incoming_sm, IncomingSms.create!(
      phone: "MyString",
      content: "MyString",
      request_type: "MyString"
    ))
  end

  it "renders the edit incoming_sm form" do
    render

    assert_select "form[action=?][method=?]", incoming_sm_path(@incoming_sm), "post" do

      assert_select "input[name=?]", "incoming_sms[phone]"

      assert_select "input[name=?]", "incoming_sms[content]"

      assert_select "input[name=?]", "incoming_sms[request_type]"
    end
  end
end
