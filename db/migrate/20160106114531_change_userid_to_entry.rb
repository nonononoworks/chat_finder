class ChangeUseridToEntry < ActiveRecord::Migration
  def up
    change_column :entries, :userid, :integer, null: false
  end

  #変更前の型
  def down
    change_column :entries, :userid, :string, null: false
  end
end
