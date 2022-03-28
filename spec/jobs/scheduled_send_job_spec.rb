# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScheduledSendJob, type: :job do
  describe '#perform' do
    let(:user) { create(:user_1) }
    let(:recipient) { create(:recipient_1, user: user, phone: '+16515550195') }
    let(:recipient_list) { create(:recipient_list_1, user: user) }

    it 'finds messages that are ready to send' do
      now = DateTime.now
      recipient_list.recipients << recipient
      m = create(:message_1, user: user, recipient_lists: [recipient_list], status: 'Pending', send_time: now - 1.minute)

      VCR.use_cassette('schedule_send_spec') do
        ScheduledSendJob.new.perform
      end

      m.reload
      expect(m.status).to eq('Sent')
      expect(m.sent_at).not_to be_nil
    end

    it 'ignores messages that are not ready to send' do
      now = DateTime.now
      recipient_list.recipients << recipient
      m = create(:message_1, user: user, recipient_lists: [recipient_list], status: 'Pending', send_time: now + 1.minute)

      ScheduledSendJob.new.perform

      m.reload
      expect(m.status).to eq('Pending')
      expect(m.sent_at).to be_nil
    end
  end
end
