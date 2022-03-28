# frozen_string_literal: true

##
class SenderService
  def self.send_recipients(message)
    message.recipient_lists.map(&:recipients).flatten.uniq.each do |r|
      send_recipient(r, message)
    end
    message.update(status: 'Sent', sent_at: Time.now)
  end

  def self.send_recipient(recipient, message)
    begin
      result = TwilioTextMessenger.new(message.content).call(recipient.phone)
    rescue Twilio::REST::RestError, Twilio::REST::TwilioError => e
      store_recipient_send(recipient, message, { status: 'Failed', error_code: e.code, error_message: e.message })
      puts "Error sending to #{recipient.phone} for #{message.id}: #{e.message}"
      return
    end
    Rails.logger.debug(result)
    store_recipient_send(recipient,
                         message,
                         { status: result.status,
                           error_code: result.error_code,
                           error_message: result.error_message,
                           sid: result.sid })
  end

  def self.store_recipient_send(recipient, message, details = {})
    MessageRecipient.create(
      message: message,
      recipient: recipient,
      status: details[:status],
      error_code: details[:error_code],
      error_message: details[:error_message],
      sid: details[:sid]
    )
  end
end
