class ChangeColumnToMessage < ActiveRecord::Migration
  # 変更内容
  def up
    change_column :messages, :user_id, :string
  end

  # 変更前の状態
  def down
    change_column :messages, :user_id, :integer
  end
end
