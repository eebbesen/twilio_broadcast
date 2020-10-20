# frozen_string_literal: true

##
class MessagesController < ApplicationController
  before_action :set_message, only: %i[show edit update destroy send_message]
  before_action :authenticate_user!, except: 'sms_status'
  skip_before_action :verify_authenticity_token, only: 'sms_status'

  # POST /messages/sms_status
  def sms_status
    logger.debug(params)
    mr = MessageRecipient.find_by(sid: params['SmsSid'])
    if status_update_valid? mr
      error_code = if params['ErrorCode']
                     mr.error_code.blank? ? params['ErrorCode'] : "#{mr.error_code}; #{params['ErrorCode']}"
                   else
                     mr.error_code
                   end

      mr.update(status: params['SmsStatus'], error_code: error_code)

      respond_to do |format|
        format.json { render json: { 'message_sid' => params['SmsSid'] }.to_json, status: :ok }
        format.html { render json: { 'message_sid' => params['SmsSid'] }.to_json, status: :ok }
      end
    else
      respond_to do |format|
        format.json do
          render json: {
            'error_message' => 'no recipient found',
            'message_sid' => params['SmsSid']
          }.to_json,
                 status: :unprocessable_entity
        end
        format.html do
          render json: { 'error_message' => 'no recipient found',
                         'message_sid' => params['SmsSid'] }.to_json,
                 status: :unprocessable_entity
        end
      end
    end
  rescue StandardError => e
    respond_to do |format|
      format.json do
        render json: { 'message_sid' => params['SmsSid'],
                       'error_message' => e.message }.to_json,
               status: :unprocessable_entity
      end
      format.html do
        render json: { 'message_sid' => params['SmsSid'],
                       'error_message' => e.message }.to_json,
               status: :unprocessable_entity
      end
    end
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
    @message.remove
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  rescue SentMessageError => e
    respond_to do |format|
      format.html { redirect_to messages_url, alert: e.message }
      format.json { render json: { 'error' => e.message }.to_json, status: :unprocessable_entity }
    end
  end

  # POST /messages/1
  def send_message
    respond_to do |format|
      notice = if !@message.sent? && @message.recipients?
                 SenderService.send_recipients(@message)
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

    unless params['To'].ends_with? recipient.recipient.phone
      logger.warn("No match for sid #{params['SmsSid']} and phone #{params['To']}")
      return false
    end
    true
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
