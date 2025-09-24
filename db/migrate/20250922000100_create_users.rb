
class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :bigserial do |t|
      t.string :name, null: false
      t.timestamps
    end
    add_index :users, :name
  end
end
