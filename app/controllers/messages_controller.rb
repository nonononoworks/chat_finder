class MessagesController < ApplicationController

  before_filter :authenticate_user!

  def create
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.build(message_params)
    @message.user_id = current_user.id
    if @message.save
      if @conversation.recipient_id == current_user.id then
        channel = @conversation.sender_id.to_s
      else
        channel = @conversation.recipient_id.to_s
      end
      @path = conversation_path(@conversation)
      Pusher["user_" + channel].trigger('chat_event', {
      	message: @message
      })
    end
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
