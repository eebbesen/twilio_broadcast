# frozen_string_literal: true

##
class RecipientListsController < ApplicationController
  before_action :set_recipient_list, only: %i[show edit update destroy]

  # GET /recipient_lists
  # GET /recipient_lists.json
  def index
    @recipient_lists = RecipientList.all.where(user: current_user)
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
    @recipient_list = RecipientList.new(recipient_list_params)

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
    params.require(:recipient_list).permit(:name, :notes, :user_id)
  end
end
