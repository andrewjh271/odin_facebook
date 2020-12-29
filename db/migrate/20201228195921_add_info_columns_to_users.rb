class AddInfoColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    change_table :users do |t|
      t.string :location
      t.string :education1
      t.string :education2
      t.string :education3
      t.string :occupation
      t.string :website
      t.date :birthday
    end
  end
end
