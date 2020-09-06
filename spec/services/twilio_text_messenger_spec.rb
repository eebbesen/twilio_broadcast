# frozen_string_literal: true

##
# This calls the real Twilio API
# make sure you have test credentials or you will incur Twilio charges
require 'rails_helper'

RSpec.describe TwilioTextMessenger do
  # uses the valid Twilio magic to number
  it 'sends successful message' do
    VCR.use_cassette('twilio_success') do
      r = TwilioTextMessenger.new('test message').call('+15005550006')

      expect(r.status).to eq('queued')
      expect(r.error_code).to be_nil
      expect(r.body).to eq('test message')
    end
  end

  # uses the invalid Twilio magic to number
  it 'sends message to invalid number' do
    VCR.use_cassette('twilio_invalid') do
      r = TwilioTextMessenger.new('test message').call('+15005550001')
    rescue StandardError => e
      expect(r).to be_nil
      expect(e.status_code).to eq(400)
      expect(e.code).to eq(21_211)
      expect(e.error_message).to eq("The 'To' number +15005550001 is not a valid phone number.")
    end
  end

  # uses the blocked Twilio magic to number
  it 'sends message to blocked number' do
    VCR.use_cassette('twilio_blocked') do
      r = TwilioTextMessenger.new('test message').call('+15005550004')
    rescue StandardError => e
      expect(r).to be_nil
      expect(e.status_code).to eq(400)
      expect(e.code).to eq(21_610)
      expect(e.error_message).to eq('The message From/To pair violates a blacklist rule.')
    end
  end

  # uses the Twilio magic to number that can't receive text messages
  it "sends message to number that can't receive text messages" do
    VCR.use_cassette('twilio_cannot_receive') do
      r = TwilioTextMessenger.new('test message').call('+15005550009')
    rescue StandardError => e
      expect(r).to be_nil
      expect(e.status_code).to eq(400)
      expect(e.code).to eq(21_614)
      expect(e.error_message).to eq('To number: +15005550009, is not a mobile number')
    end
  end
end
