
class SleepSession < ApplicationRecord
  belongs_to :user

  scope :completed, -> { where.not(woke_at: nil) }
  scope :during_last_week, lambda {
    to   = Time.current.end_of_day
    from = (to - 7.days).beginning_of_day
    where(woke_at: from..to)
  }

  before_save :compute_duration

  private
  
  def compute_duration
    if slept_at && woke_at
      self.duration_sec = (woke_at - slept_at).to_i
    end
  end

end
