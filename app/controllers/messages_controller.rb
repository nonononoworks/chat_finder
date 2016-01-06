class MessagesController < ApplicationController

  def create
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.build(message_params)
    @message.user_id = session[:matching_id]

    if @message.save
      if @conversation.recipient_id == session[:matching_id] then
        channel = @conversation.sender_id
      else
        channel = @conversation.recipient_id
      end
      @path = conversation_path(@conversation)
      Pusher[channel].trigger('conversation', {
      	message: @message
      })
    end
  end

  def index
    @conversation = Conversation.find(params[:conversation_id])
    @message = Message.find(params[:message]["id"])
    render "create"
  end
 
  private
 
  def message_params
    params.require(:message).permit(:body)
  end

	#def index
	#	count = Message.count
	#	@message = Message.find(count)
	#end

	#def create
	#	Pusher['general_channel'].trigger('chat_event', {
	#		message: params[:message]
	#	})
	#	render :text => 'OK', :status => 200
	#end
end
