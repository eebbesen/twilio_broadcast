# frozen_string_literal: true

##
class IncomingSmsController < ApplicationController
  # GET /incoming_sms
  # GET /incoming_sms.json
  def index
    @incoming_sms = IncomingSms.all
  end

  # GET /incoming_sms/1
  # GET /incoming_sms/1.json
  def show; end

end