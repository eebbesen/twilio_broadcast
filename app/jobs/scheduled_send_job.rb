# frozen_string_literal: true

##
class ScheduledSendJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    Message.ready_to_send.each do |m|
      SenderService.send_recipients(m)
    end
  end
end
