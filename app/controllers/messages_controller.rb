# frozen_string_literal: true

##
class MessagesController < ApplicationController
  before_action :set_message, only: %i[show edit update destroy send_message]
  before_action :authenticate_user!, except: 'sms_status'
  skip_before_action :verify_authenticity_token, only: 'sms_status'

  # POST /messages/sms_status
  def sms_status
    mr = MessageRecipient.find_by(sid: params['SmsSid'])
    return unless status_update_valid? mr

    error_code = if params['ErrorCode']
      mr.error_code.blank? ? params['ErrorCode'] : "#{mr.error_code}; #{params['ErrorCode']}"
    else
      mr.error_code
    end

    mr.update(status: params['SmsStatus'], error_code: error_code)
  end

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.where(user: current_user)
  end

  # GET /messages/1
  # GET /messages/1.json
  def show; end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit; end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params.merge({ user_id: current_user.id }))

    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'Message was successfully created.' }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /messages/1
  def send_message
    respond_to do |format|
      notice = if !@message.sent? && @message.recipients?
                 send_recipients
                 'Message sent'
               else
                 'Please select recipients'
               end
      format.html { redirect_to @message, notice: notice }
    end
  end

  private

  def status_update_valid?(recipient)
    return false unless recipient

    unless "+#{recipient.recipient.phone}" == params['To']
      logger.warn("No match for sid #{params['SmsSid']} and phone #{params['To']}")
      return false
    end
    true
  end

  def send_recipients
    @message.recipient_lists.map(&:recipients).flatten.uniq.each do |r|
      send_recipient(r)
    end
    @message.update(status: 'Sent', sent_at: Time.now)
  end

  def send_recipient(recipient)
    begin
      result = TwilioTextMessenger.new(@message.content).call(recipient.phone)
    rescue Twilio::REST::RestError => e
      store_recipient_send(recipient, { status: 'Failed', error_code: e.code, error_message: e.message })
      puts "Error sending to #{recipient.phone} for #{@message.id}: #{e.message}"
      return
    end
    store_recipient_send(recipient, { status: result.status,
                                      error_code: result.error_code,
                                      error_message: result.error_message,
                                      sid: result.sid })
  end

  def store_recipient_send(recipient, details = {})
    MessageRecipient.create(
      message: @message,
      recipient: recipient,
      status: details[:status],
      error_code: details[:error_code],
      error_message: details[:error_message],
      sid: details[:sid]
    )
  end

  # User scope messages
  def set_message
    @message = Message.where(id: params[:id], user: current_user).first
  end

  # Only allow a list of trusted parameters through.
  def message_params
    params.require(:message).permit(:content, :id, :user_id, recipient_list_ids: [])
  end
end
