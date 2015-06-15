class MessagesController < ApplicationController

  def create
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.build(message_params)
    @message.user_id = current_user.id
    @message.save!
 
    @path = conversation_path(@conversation)
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
