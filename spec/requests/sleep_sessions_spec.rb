
require 'rails_helper'

RSpec.describe "SleepSessions API", type: :request do
  let(:user) { create(:user) }

  it "clock in then clock out returns success and share links" do
    post "/api/v1/users/#{user.id}/sleep_sessions/clock_in"
    expect(response).to have_http_status(:created)

    post "/api/v1/users/#{user.id}/sleep_sessions/clock_out"
    expect(response).to have_http_status(:ok)
    json = JSON.parse(response.body)
    expect(json["success"]).to eq(true)
    expect(json["share_links"]["facebook"]).to match(/facebook/)
  end

  it "lists clocked-ins ordered by created_at" do
    create(:sleep_session, user: user)
    create(:sleep_session, user: user)
    get "/api/v1/users/#{user.id}/sleep_sessions"
    expect(response).to have_http_status(:ok)
    arr = JSON.parse(response.body)
    expect(arr.size).to eq(2)
  end
end
