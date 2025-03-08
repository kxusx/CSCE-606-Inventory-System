class CreateSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :login_time
      t.datetime :logout_time

      t.timestamps
    end
  end
end
