class AddIsAdminTokenToFnt < ActiveRecord::Migration[5.2]
  def change
  	add_column :firebase_notification_tokens, :reg_type, :string
  end
end
