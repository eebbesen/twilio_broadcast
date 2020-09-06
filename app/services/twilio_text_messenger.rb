# frozen_string_literal: true

##
class TwilioTextMessenger
  attr_reader :content

  def initialize(content)
    @content = content
  end

  def call(recipient)
    Twilio::REST::Client.new.messages.create(
      from: ENV['TWILIO_FROM_PHONE_NUMBER'],
      to: recipient,
      body: content
    )
  end
end
