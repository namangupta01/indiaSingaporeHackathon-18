class CreateFirebaseNotificationTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :firebase_notification_tokens do |t|
    	t.string :registration_id
      t.timestamps
    end
  end
end
