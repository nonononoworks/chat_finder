class EntriesController < ApplicationController
  def create
    if session[:matching_id] then
    else
      session[:matching_id] = SecureRandom.uuid
    end
    guest = Guest.find_by(userid:session[:matching_id])
    if !guest
      guest = Guest.new(guest_params)
      guest.userid = session[:matching_id]
      guest.save
    end
    @matching_id = guest.id.to_s
    challenge_response(guest)

  end
  def delete
    userid = params[:userid]
    @guest = Guest.find_by(id: userid.to_i)
    if @guest
      @guest.destroy #entry deleted by association
    end
    if params[:matching_to]
      Pusher['user_' + params[:matching_to]].trigger('cancelled', { })
    end
    flash[:success] = "cancelled"
    @guest = Guest.new
  end

  def matching
    @matching_from = params[:matching_from]
    @matching_to = params[:matching_to]
  end

  private
  def guest_params
    params.require(:guest).permit(:username, :sex, :userid)
  end

  def challenge_response(guest)
    search_sex = guest.sex === "M" ? "F" : "M"
    waiting_entry = Entry.find_by(sex: search_sex)
    if waiting_entry.nil? then
      # create record and leave
      entry = Entry.find_by(userid: guest.id)
      if !entry
        entry = guest.build_entry(sex: guest.sex)
        entry.save
      end
      render "create"
    else
      # join matching
      waiting_user = Guest.find_by(id: waiting_entry.userid)
      response = Pusher.get('/channels/' + 'user_' + waiting_user.id.to_s)
      event_waiting = response[:occupied]
      if event_waiting
        @matching_to = waiting_user.id
        @matching_from = guest.id
        Pusher['user_' + waiting_user.id.to_s].trigger('matching', {
            matching_from: @matching_from,
            matching_to: @matching_to
        })
        render "matching"
      else
        waiting_user.destroy
        challenge_response(guest)
      end
    end
  end


end
