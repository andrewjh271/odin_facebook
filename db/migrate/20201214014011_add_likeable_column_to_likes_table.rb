class AddLikeableColumnToLikesTable < ActiveRecord::Migration[6.0]
  def change
    add_reference :likes, :likable, polymorphic: true, null: false
    remove_reference :likes, :post, foreign_key: true, null: false
  end
end
