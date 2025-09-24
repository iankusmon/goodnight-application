
require 'rails_helper'

RSpec.describe Follow, type: :model do
  it "validates uniqueness" do
    a = create(:user); b = create(:user)
    create(:follow, follower: a, followed: b)
    dup = build(:follow, follower: a, followed: b)
    expect(dup).not_to be_valid
  end

  it "prevents self follow" do
    u = create(:user)
    f = build(:follow, follower: u, followed: u)
    expect(f).not_to be_valid
  end
end
