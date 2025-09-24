
class Api::V1::SleepSessionsController < ApplicationController
  include Shareable
  before_action :set_user

  def clock_in
    @user.with_lock do
      if @user.sleep_sessions.where(woke_at: nil).exists?
        return render json: { error: "already clocked in" }, status: :unprocessable_entity
      end
      session = @user.sleep_sessions.create!(slept_at: Time.current)
      render json: serialize_session(session).merge(success: true, message: "Clock in success"), status: :created
    end
  end

  def clock_out
    @user.with_lock do
      session = @user.sleep_sessions.where(woke_at: nil).order(:slept_at).last
      return render json: { error: "no open session" }, status: :unprocessable_entity unless session

      session.update!(woke_at: Time.current)
      render json: serialize_session(session).merge(success: true, message: "Congrats! You’ve clocked out successfully 🎉", share_links: build_share_links(session)), status: :ok
    end
  end

  def index
    sessions = @user.sleep_sessions.order(:created_at)
    render json: sessions.map { |s| serialize_session(s) }
  end

  private
  def set_user; @user = User.find(params[:user_id]); end

  def serialize_session(s)
    {
      id: s.id,
      user_id: s.user_id,
      slept_at: s.slept_at,
      woke_at: s.woke_at,
      duration_sec: s.duration_sec
    }
  end
end
