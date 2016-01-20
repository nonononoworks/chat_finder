class AddStatusToConversation < ActiveRecord::Migration
  def change
    add_column :conversations, :status, :integer, default: 0, null: false, limit: 1
  end
end
