class NotificationController < ApplicationController
	def set_registraion_token
		registration_id = params["registration_id"]
		if registration_id.blank?
			return response_data({}, "No Registration Id", 404)
		else
			fnt = FirebaseNotificationToken.where(registration_id: registration_id)
			unless fnt.any?
				fnt = FirebaseNotificationToken.create(registration_id: registration_id)
				fnt.save!
				return response_data(fnt, "Token Created", 200)	
			else
				fnt = fnt.first
				return response_data(fnt, "Already Present", 200)	
			end
		end
	end

	def send_notification
		
	end
end
# def response_data(data, message, status, error:nil, disabled:false, update:false, external_rating: nil, params: {})