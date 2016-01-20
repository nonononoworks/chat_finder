module ConversationsHelper
  def interlocutor(conversation)
    Guest.find_by(userid: session[:matching_id]).id == conversation.recipient_id ? conversation.sender_id : conversation.recipient_id
  end
end
