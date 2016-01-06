class EntriesController < ApplicationController
  def create
    if session[:matching_id] then
    else
      session[:matching_id] = SecureRandom.uuid
    end
    if session[:sex] then
    else
      session[:sex] = params[:entry][:sex]
    end
    sex = session[:sex]
    @session_user = session[:matching_id]

    # Search Entry Table
    challenge_response(@session_user, sex)

  end

  def delete
    username = params[:username]
    @entry = Entry.find_by(username: username)
    if @entry
      @entry.destroy
    end
    if params[:matching_to]
      Pusher[params[:matching_to]].trigger('cancelled', { })
    end
    flash[:success] = "cancelled"
    @entry = Entry.new
    # redirect_to root_url
  end

  def matching
    @matching_from = params[:matching_from]
    @matching_to = params[:matching_to]
  end

  private
    def challenge_response(user,sex)
      search_sex = sex === "M" ? "F" : "M"
      waiting = Entry.find_by(sex: search_sex)
      @entry = Entry.new(username: user, sex: sex)
      if waiting.nil? then
        # create record and leave
        @entry.save
        render "create"
      else
        # join matching
        response = Pusher.get('/channels/' + waiting.username)
        event_waiting = response[:occupied]
        if event_waiting
          @matching_to = waiting.username
          @matching_from = user
          Pusher[waiting.username].trigger('matching', {
              matching_from: @matching_from,
              matching_to: @matching_to
          })
          render "matching"
        else
          waiting.destroy
          challenge_response(user,sex)
        end
      end
    end
end
