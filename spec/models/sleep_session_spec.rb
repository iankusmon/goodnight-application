
require 'rails_helper'

RSpec.describe SleepSession, type: :model do
  it "computes duration on save" do
    s = create(:sleep_session, slept_at: Time.current - 7.hours, woke_at: Time.current)
    expect(s.duration_sec).to be_within(5).of(7.hours.to_i)
  end
end
