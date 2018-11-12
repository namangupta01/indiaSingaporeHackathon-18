class CreateNotificationUserMappings < ActiveRecord::Migration[5.2]
  def change
    create_table :notification_user_mappings do |t|
    	t.references :notification
    	t.string :user
    	t.timestamps
    end
  end
end
