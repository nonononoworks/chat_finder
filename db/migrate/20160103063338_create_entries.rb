class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.string :username, :null => false
      t.string :sex, :null => false

      t.timestamps
    end
  end
end
