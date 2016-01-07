class AddUseridToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :userid, :string
  end
end
