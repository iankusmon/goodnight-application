# 📘 Goodnight Application (Rails 7.1 API)

## 🚀 Quickstart Setup

1. **Clone the repo**
   ```bash
   git clone <repo-url>
   cd goodnight-application
   ```

2. **Install gems (into `vendor/bundle`)**
   ```bash
   bundle install --path vendor/bundle
   ```

3. **Setup the databases (development + test)**
   ```bash
   bin/rails db:create db:migrate
   bin/rails db:test:prepare
   ```

   if error, cause of ruby version do this:
   
   ```bash
   mise local ruby@3.2.2
   exec $SHELL -l
   ruby -v   # should print 3.2.2
   which ruby
   ```

4. **Run the test suite**
   ```bash
   bin/rspec
   ```

5. **Start the server**
   ```bash
   bin/rails s
   ```
   App will be available at [http://localhost:3000](http://localhost:3000).

---

## 🧪 Testing Scenarios

- **RSpec**
  ```bash
  bin/rspec
  ```

- **Run specific group**
  ```bash
  bin/rspec spec/requests/sleep_sessions_spec.rb
  bin/rspec spec/requests/follows_and_feed_spec.rb
  ```

- **API Smoke Test with `curl`**
  After starting the server, run the `demo_scenarios.sh` script:
  ```bash
  ./demo_scenarios.sh
  ```

---

## ⚙️ Requirements

- Ruby 3.2.2 (recommend using [mise](https://mise.jdx.dev/) or rbenv)
- Rails 7.1
- PostgreSQL (user `postgres` or set `PGUSER`, `PGPASSWORD`, `PGHOST` via env vars)
- `jq` for pretty-printing JSON in the demo script (optional)
