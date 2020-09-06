# frozen_string_literal: true

##
class TwilioTextMessenger
  attr_reader :content

  def initialize(content)
    @content = content
  end

  def call(recipient)
    client = Twilio::REST::Client.new
    client.messages.create(
                             from: ENV['TWILIO_FROM_PHONE_NUMBER'],
                             to: recipient,
                             body: content
                           )
  end
end
