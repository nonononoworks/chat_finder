class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.string :userid
      t.string :username
      t.string :sex

      t.timestamps
    end
  end
end
