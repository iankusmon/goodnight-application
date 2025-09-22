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

## 🚀 Notes for Manager

- **Reliability**: APIs handle both success and error cases gracefully.  
- **Scalability**: Indexes and DB constraints ensure data integrity even under load.  
- **Sharing Feature**: Clock Out returns share links for Facebook, WhatsApp, Instagram.  
- **Team Onboarding**: Setup instructions in `README.md` allow anyone to run `bin/rspec` and confirm green tests.  

---

✅ **Conclusion:** The Goodnight Application backend is fully tested and ready for demo / review.
