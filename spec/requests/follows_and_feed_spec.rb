
require 'rails_helper'

RSpec.describe "Follows & Feed API", type: :request do
  let(:me)   { create(:user) }
  let(:a)    { create(:user, name: "User A") }
  let(:b)    { create(:user, name: "User B") }

  before do
    post "/api/v1/users/#{me.id}/follows", params: { followed_id: a.id }
    post "/api/v1/users/#{me.id}/follows", params: { followed_id: b.id }

    create(:sleep_session, user: a, slept_at: 6.days.ago.change(hour: 23), woke_at: 5.days.ago.change(hour: 7))
    create(:sleep_session, user: b, slept_at: 5.days.ago.change(hour: 0), woke_at: 5.days.ago.change(hour: 6, min:30))
  end

  it "returns friends' last-week records sorted by duration desc" do
    get "/api/v1/users/#{me.id}/feed"
    expect(response).to have_http_status(:ok)
    names = JSON.parse(response.body).map { |r| r["user_name"] }
    expect(names.first).to eq("User A")
  end

  it "unfollow works" do
    delete "/api/v1/users/#{me.id}/follows/#{a.id}"
    expect(response).to have_http_status(:no_content)
  end
end
