
class CreateSleepSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :sleep_sessions, id: :bigserial do |t|
      t.bigint :user_id, null: false
      t.datetime :slept_at, null: false
      t.datetime :woke_at
      t.integer :duration_sec
      t.timestamps
    end
    add_foreign_key :sleep_sessions, :users
    add_index :sleep_sessions, [:user_id, :slept_at]
    add_index :sleep_sessions, [:user_id, :woke_at]
    add_index :sleep_sessions, :woke_at

    reversible do |dir|
      dir.up do
        execute <<~SQL
          CREATE UNIQUE INDEX idx_unique_open_sleep_session
          ON sleep_sessions (user_id)
          WHERE woke_at IS NULL;
        SQL
        execute <<~SQL
          ALTER TABLE sleep_sessions
          ADD CONSTRAINT slept_before_woke
          CHECK (woke_at IS NULL OR slept_at < woke_at);
        SQL
      end
      dir.down do
        execute "DROP INDEX IF EXISTS idx_unique_open_sleep_session;"
        execute "ALTER TABLE sleep_sessions DROP CONSTRAINT IF EXISTS slept_before_woke;"
      end
    end
  end
end
