class CreateWordcounts < ActiveRecord::Migration
  def change
    create_table :wordcounts do |t|
      t.integer :count
      t.integer :year
      t.integer :month
      t.integer :day
      t.integer :user_id
    end
  end
end
