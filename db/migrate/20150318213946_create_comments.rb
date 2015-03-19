class CreateComments < ActiveRecord::Migration
  def up
    create_table :comments do |t|
      t.text    :description, null: false
      t.integer :meetup_id,   null: false
      t.integer :user_id ,    null: false

      t.timestamps
    end
  end
  def down
    drop_table :comments
  end
end
