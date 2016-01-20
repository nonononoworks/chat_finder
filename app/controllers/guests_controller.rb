class GuestsController < ApplicationController
  def create
    guest_user # guest_userを作成する
    redirect_to :controller=>:conversations, :method=>:post
  end
end