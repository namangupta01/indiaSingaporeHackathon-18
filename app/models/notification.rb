class Notification < ApplicationRecord
	has_many :notification_user_mappings
end
