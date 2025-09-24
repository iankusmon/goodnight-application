require 'rails_helper'

RSpec.describe "Large data scenarios", type: :request do
  let!(:users) { create_list(:user, 1000) }

  describe "GET /api/v1/users" do
    it "returns all users without crashing" do
      get "/api/v1/users"
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.size).to eq(1000)
    end
  end

  describe "GET /api/v1/users/:id/sleep_sessions" do
    let!(:user) { users.first }

    before do
      create_list(:sleep_session, 1000, user: user, woke_at: Time.current, slept_at: 8.hours.ago)

    end

    it "returns 1000 sessions ordered by created_at" do
      get "/api/v1/users/#{user.id}/sleep_sessions"
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.size).to eq(1000)
      # Ensure sorted by created_at desc
      created_times = body.map { |s| s["created_at"] }
      expect(created_times).to eq(created_times.sort.reverse)
    end
  end
end
