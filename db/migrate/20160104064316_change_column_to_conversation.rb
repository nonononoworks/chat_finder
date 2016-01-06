class ChangeColumnToConversation < ActiveRecord::Migration
  # 変更内容
  def up
    change_column :conversations, :sender_id, :string
    change_column :conversations, :recipient_id, :string
  end

  # 変更前の状態
  def down
    change_column :conversations, :sender_id, :integer
    change_column :conversations, :recipient_id, :integer
  end
end
