class ConversationsController < ApplicationController

  def index
    @your_id = params[:sender_id]
    @conversation = Conversation.new
    @messages = @conversation.messages
  end

  def ready
    @conversation = Conversation.find_by(id: params[:id])
    if @conversation.waiting?
      @conversation.ready!
    end
    render :nothing => true
  end

  def create
    #Guest作成
    user = current_or_guest_user
    @matching_id = user.id.to_s
    # response = Pusher.get('/channels/' + 'user_' + guest.id.to_s)
    # if response[:occupied]
    #   Pusher['user_' + guest.id.to_s].trigger('cancelled', { })
    # end
    challenge_response(user)
  end
 
  def show
    @your_id = params[:your_id]
    @conversation = Conversation.find(params[:id])
    @reciever = interlocutor(@conversation)
    @messages = @conversation.messages
    @message = Message.new
    respond_to do |format|
      format.js
      format.html
    end
  end
 
  private
  def guest_params
    params.require(:guest).permit(:username, :sex)
  end
  def challenge_response(user)
    #search_sex = guest.sex === "M" ? "F" : "M"
    border_time = Time.zone.now - 10
    @conversation = Conversation.where("recipient_id IS ? AND status = 1",nil).first

    if @conversation.nil? then
      # create conversation
      old_conversation = Conversation.where("sender_id = ? AND recipient_id IS ? AND status = 0",user.id,nil).first
      if old_conversation
        old_conversation.destroy
        challenge_response(user)
      else
        @conversation = Conversation.create!(sender_id: user.id,recipient_id: nil, status: 0)
        redirect_to conversation_path(:id => @conversation.id, :your_id => user.id) and return
      end
    else
      waiting_user = User.find_by(id: @conversation.sender_id)
      if waiting_user.id === user.id
        @conversation.destroy
      else
        response = Pusher.get('/channels/' + 'chat_' + waiting_user.id.to_s)
        event_waiting = response[:occupied]
        if event_waiting
          # join
          Pusher['chat_' + @conversation.sender_id.to_s].trigger('starting', {
              room_id: @conversation.id,
              your_id: guest.id
          })
          @conversation.update(recipient_id:user.id,status: 2)
          redirect_to :controller=>"conversations", :action => "show",
                      :id => @conversation.id, :your_id => user.id and return
        else
          @conversation.destroy
          waiting_user.destroy
        end
      end
      challenge_response(guest)
    end
  end

  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end
 
  def interlocutor(conversation)
    Guest.find_by(userid: session[:session_id]).id == conversation.recipient_id ? conversation.sender_id : conversation.recipient_id
  end
end
