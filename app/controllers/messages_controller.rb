class MessagesController < ApplicationController

  def create
    @conv_id = params[:conversation_id]
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.build(message_params)
    @your_id = params[:your_id].to_i
    @message.user_id = @your_id

    if @message.save
      if @conversation.recipient_id.to_s == @your_id.to_s then
        channel = @conversation.sender_id
      else
        channel = @conversation.recipient_id
      end
      @path = conversation_path(@conversation)
      response = Pusher.get('/channels/' + channel.to_s)
      Pusher['user_' + channel.to_s].trigger('chat_event', {
      	message: @message
      })
    end
  end

  def index
    @your_id = params[:your_id]
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
