class MessagesController < ApplicationController
  before_action :set_message, only: %i[ show update destroy ]

  # GET /messages
  def index
    @messages = Message.all

    render json: @messages
  end

  # GET /messages/1
  def show
    render json: @message
  end

  # POST /messages
  def create
    @message = Message.new(message_params)

    if @message.save
      render json: @message, status: :created, location: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /messages/1
  def update
    if @message.update(message_params)
      render json: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /messages/1
  def destroy
    @message.destroy
  end
  
  # DELETE ALL MESSAGES
  def destroy_all
    if authenticate_request
      Message.destroy_all
      render json: { message: 'All messages have been deleted.' }
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:body, :sender)
    end
    #Authenticate delete request is from me
    def authenticate_request
      secret_password = ENV["DELETE_CHAT_PASSWORD"]
      request_password = request.headers["X-Delete-Chat-Password"]
      secret_password == request_password
    end
end
