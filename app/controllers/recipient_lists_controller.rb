# frozen_string_literal: true

##
class RecipientListsController < ApplicationController
  before_action :set_recipient_list, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: 'subscribe'
  skip_before_action :verify_authenticity_token, only: 'subscribe'

  # POST /subscribe
  def subscribe
    logger.error("params: #{params}")

    list = RecipientList.find_by(keyword: params['Body'].downcase)
    recipient = Recipient.where(phone: params['From'], user: list.user).first_or_create!
    RecipientListMember.where(recipient_list: list, recipient: recipient).first_or_create!
    logger.error("list: #{list}")
    logger.error("recipient: #{recipient}")
    response = Twilio::TwiML::MessagingResponse.new
    response.message do |message|
      message.body "You are now subscribed to receive messages from #{list.name}. Respond with STOP #{list.keyword.upcase} to be removed from the list."
    end
    render xml: response.to_s
  rescue StandardError => e
    logger.error("error adding #{params[:phone]} to keyword #{params['Body']}\n#{e.message}")
    response = Twilio::TwiML::MessagingResponse.new
    response.message do |message|
      message.body "There was an error processing your text to signup for #{params['Body']}. Please call #{ENV['TWILIO_FROM_PHONE_NUMBER']}"
    end
    render xml: response.to_s
  end

  # GET /recipient_lists
  # GET /recipient_lists.json
  def index
    @recipient_lists = RecipientList.where(user: current_user)
  end

  # GET /recipient_lists/1
  # GET /recipient_lists/1.json
  def show; end

  # GET /recipient_lists/new
  def new
    @recipient_list = RecipientList.new
  end

  # GET /recipient_lists/1/edit
  def edit; end

  # POST /recipient_lists
  # POST /recipient_lists.json
  def create
    @recipient_list = RecipientList.new(recipient_list_params.merge(user_id: current_user.id))

    respond_to do |format|
      if @recipient_list.save
        format.html { redirect_to @recipient_list, notice: 'Recipient list was successfully created.' }
        format.json { render :show, status: :created, location: @recipient_list }
      else
        format.html { render :new }
        format.json { render json: @recipient_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipient_lists/1
  # PATCH/PUT /recipient_lists/1.json
  def update
    respond_to do |format|
      if @recipient_list.update(recipient_list_params)
        format.html { redirect_to @recipient_list, notice: 'Recipient list was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipient_list }
      else
        format.html { render :edit }
        format.json { render json: @recipient_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipient_lists/1
  # DELETE /recipient_lists/1.json
  def destroy
    @recipient_list.destroy
    respond_to do |format|
      format.html { redirect_to recipient_lists_url, notice: 'Recipient list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_recipient_list
    @recipient_list = RecipientList.where(id: params[:id], user: current_user).first
  end

  # Only allow a list of trusted parameters through.
  def recipient_list_params
    params.require(:recipient_list).permit(:name, :notes, :user_id, :keyword)
  end
end
