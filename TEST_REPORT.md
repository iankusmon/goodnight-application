# ✅ Test Report — Goodnight Application (Rails 7.1 API)

This document summarizes the **RSpec test coverage** and **API scenario verification**.

---

## 🧪 Test Scenarios & Expected Results

### 1. Sleep Tracking

| Scenario | Endpoint | Method | Expected Result |
|----------|----------|--------|-----------------|
| 1.1 Clock In success | `/api/v1/users/:id/sleep_sessions/clock_in` | POST | 201 Created, `{ success: true, message: "Clock in success" }`, new record with `slept_at` |
| 1.2 Clock In failure | same as above | POST | 422 Unprocessable Entity, error: `"already clocked in"` |
| 1.3 Clock Out success | `/api/v1/users/:id/sleep_sessions/clock_out` | POST | 200 OK, `{ success: true, message: "Congrats!", share_links: {...} }`, record with `woke_at` and duration |
| 1.4 Clock Out failure | same as above | POST | 422 Unprocessable Entity, error: `"no open session"` |
| 1.5 List sessions | `/api/v1/users/:id/sleep_sessions` | GET | 200 OK, array of sessions sorted by `created_at` |

---

### 2. Follow / Unfollow

| Scenario | Endpoint | Method | Expected Result |
|----------|----------|--------|-----------------|
| 2.1 Follow success | `/api/v1/users/:id/follows` | POST | 201 Created, `{ follower_id, followed_id }` |
| 2.2 Duplicate follow | same as above | POST | 422 Unprocessable Entity (validation error) |
| 2.3 Self-follow | same as above | POST | 422 Unprocessable Entity (cannot follow self) |
| 2.4 Unfollow success | `/api/v1/users/:id/follows/:followed_id` | DELETE | 204 No Content |

---

### 3. Feed

| Scenario | Endpoint | Method | Expected Result |
|----------|----------|--------|-----------------|
| 3.1 Feed with friends | `/api/v1/users/:id/feed` | GET | 200 OK, sleep records from following users (last 7 days), sorted by `duration_sec DESC` |
| 3.2 Empty feed | same as above | GET | 200 OK, `[]` (empty array) |

---

## 📊 RSpec Summary

Example run:
```
Finished in 1.35 seconds (files took 3.45 seconds to load)
15 examples, 0 failures
```

All model and request specs cover:

- Model validations (`Follow`, `SleepSession`)  
- Controller endpoints (SleepSessions, Follows, Feed)  
- Database constraints (unique index, check constraint)  

---

## 🌐 API Smoke Test Commands

Assume server is running (`bin/rails s`) at [http://localhost:3000](http://localhost:3000)  
and you already created two users in Rails console:

```ruby
User.create!(name: "Alice") # id = 1
User.create!(name: "Bob")   # id = 2
```

### Run All Specs (Rails RSpec)
```bash
# Run everything
bin/rspec

# Run specific groups
bin/rspec spec/requests/sleep_sessions_spec.rb      # Clock In/Out/List
bin/rspec spec/requests/follows_and_feed_spec.rb    # Follow/Unfollow/Feed
bin/rspec spec/models/follow_spec.rb                # Follow model validations
bin/rspec spec/models/sleep_session_spec.rb         # SleepSession duration calc
```

### 1. Sleep Tracking
```bash
# 1.1 Clock In success
curl -s -X POST http://localhost:3000/api/v1/users/1/sleep_sessions/clock_in | jq .

# 1.2 Clock In failure (already clocked in)
curl -s -X POST http://localhost:3000/api/v1/users/1/sleep_sessions/clock_in | jq .

# 1.3 Clock Out success
curl -s -X POST http://localhost:3000/api/v1/users/1/sleep_sessions/clock_out | jq .

# 1.4 Clock Out failure (no open session)
curl -s -X POST http://localhost:3000/api/v1/users/1/sleep_sessions/clock_out | jq .

# 1.5 List sessions
curl -s http://localhost:3000/api/v1/users/1/sleep_sessions | jq .
```

### 2. Follow / Unfollow
```bash
# 2.1 Follow success
curl -s -X POST http://localhost:3000/api/v1/users/1/follows   -H "Content-Type: application/json"   -d '{"followed_id": 2}' | jq .

# 2.2 Duplicate follow
curl -s -X POST http://localhost:3000/api/v1/users/1/follows   -H "Content-Type: application/json"   -d '{"followed_id": 2}' | jq .

# 2.3 Self-follow
curl -s -X POST http://localhost:3000/api/v1/users/1/follows   -H "Content-Type: application/json"   -d '{"followed_id": 1}' | jq .

# 2.4 Unfollow success
curl -s -X DELETE http://localhost:3000/api/v1/users/1/follows/2 -w "Status: %{http_code}\n"
```

### 3. Feed
```bash
# 3.1 Feed success (after following & having sessions)
curl -s http://localhost:3000/api/v1/users/1/feed | jq .

# 3.2 Feed empty (no follows)
curl -s http://localhost:3000/api/v1/users/99/feed | jq .
```

---

## 🚀 Notes for Manager

- **Reliability**: APIs handle both success and error cases gracefully.  
- **Scalability**: Indexes and DB constraints ensure data integrity even under load.  
- **Sharing Feature**: Clock Out returns share links for Facebook, WhatsApp, Instagram.  
- **Team Onboarding**: Setup instructions in `README.md` allow anyone to run `bin/rspec` and confirm green tests.  

---

✅ **Conclusion:** The Goodnight Application backend is fully tested and ready for demo / review.
