class ConversationsController < ApplicationController

  def index
    sender_id = params[:sender_id]
    receipient_id = params[:recipient_id]
    @receipient_id = receipient_id

    Pusher[params[:recipient_id]].trigger('starting', {
        event_type: "confirm"
    })
  end

  def create
    if Conversation.between(params[:sender_id],params[:recipient_id]).present?
      @conversation = Conversation.between(params[:sender_id],params[:recipient_id]).first
    else
      @conversation = Conversation.create!(conversation_params)
      Pusher[params[:recipient_id]].trigger('starting', {
          event_type: "starting",
          sender_id: params[:sender_id],
          recipient_id: params[:recipient_id]
      })
    end
    @reciever = interlocutor(@conversation)
    @messages = @conversation.messages
    @message = Message.new
    conversation_id = @conversation.id.to_s
    url = '/conversations/' + conversation_id
    render js: %(window.location = '#{url}') and return
  end
 
  def show
    @conversation = Conversation.find(params[:id])
    @reciever = interlocutor(@conversation)
    @messages = @conversation.messages
    @message = Message.new
  end
 
  private
  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end
 
  def interlocutor(conversation)
    session[:matching_id] == conversation.recipient ? conversation.sender : conversation.recipient
  end
end
