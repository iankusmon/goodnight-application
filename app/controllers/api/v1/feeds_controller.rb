
class Api::V1::FeedsController < ApplicationController
  before_action :set_user

  def index
    friend_ids = @user.following.select(:id)
    sessions = SleepSession.completed.where(user_id: friend_ids).during_last_week.order(duration_sec: :desc, woke_at: :desc, id: :desc)
    render json: sessions.includes(:user).map { |s|
      {
        user_id: s.user_id,
        user_name: s.user.name,
        slept_at: s.slept_at,
        woke_at: s.woke_at,
        duration_sec: s.duration_sec
      }
    }
  end

  private
  def set_user; @user = User.find(params[:user_id]); end
end
