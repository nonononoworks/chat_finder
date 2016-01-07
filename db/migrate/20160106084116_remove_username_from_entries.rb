class RemoveUsernameFromEntries < ActiveRecord::Migration
  def change
    remove_column :entries, :username, :string
  end
end
