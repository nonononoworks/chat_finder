class ChangeColumnsToConversation < ActiveRecord::Migration
  def up
    change_column :conversations, :sender_id, 'sender_id USING CAST(sender_id AS integer)'
    change_column :conversations, :recipient_id, 'recipient_id USING CAST(sender_id AS integer)'
  end

  #変更前の型
  def down
    change_column :conversations, :sender_id, :string
    change_column :conversations, :recipient_id, :string
  end
end
