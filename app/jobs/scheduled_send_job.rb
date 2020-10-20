class ScheduledSendJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Message.ready_to_send.each do |m|
      SenderService.send_recipients(m)
    end
  end
end
