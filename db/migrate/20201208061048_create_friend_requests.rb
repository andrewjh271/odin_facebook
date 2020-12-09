class CreateFriendRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :friend_requests do |t|
      t.references :requester, null: false, foreign_key: { to_table: :users }
      t.references :recipient, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
