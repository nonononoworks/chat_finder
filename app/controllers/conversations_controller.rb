class ConversationsController < ApplicationController

  def index
    sender_id = params[:sender_id]
    receipient_id = params[:recipient_id]
    @receipient_id = receipient_id

    Pusher['user_' + params[:recipient_id]].trigger('starting', {
        event_type: "confirm"
    })
  end

  def create
    if Conversation.between(params[:sender_id],params[:recipient_id]).present?
      @conversation = Conversation.between(params[:sender_id],params[:recipient_id]).first
    else
      @conversation = Conversation.create!(conversation_params)
    end
    Pusher['user_' + params[:recipient_id]].trigger('starting', {
        event_type: "starting",
        room_id: @conversation.id,
        sender_id: params[:sender_id],
        recipient_id: params[:recipient_id]
    })
    #Delete Entry
    Entry.find_by(userid: [ params[:sender_id],params[:recipient_id] ]).destroy
    @reciever = interlocutor(@conversation)
    @messages = @conversation.messages
    @message = Message.new
    redirect_to :action => "show", :id => @conversation.id, :your_id => params[:sender_id]
  end
 
  def show
    @your_id = params[:your_id]
    @conversation = Conversation.find(params[:id])
    @reciever = interlocutor(@conversation)
    @messages = @conversation.messages
    @message = Message.new
    url = '/conversations/' + params[:id] + "?your_id=" + @your_id
    respond_to do |format|
      format.js {render js: %(window.location = '#{url}') and return}
      format.html
    end
  end
 
  private
  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end
 
  def interlocutor(conversation)
    Guest.find_by(userid: session[:matching_id]).id == conversation.recipient_id ? conversation.sender_id : conversation.recipient_id
  end
end
