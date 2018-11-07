class NotificationController < ApplicationController
	skip_before_action :verify_authenticity_token
	require 'active_support'
	require "active_support/core_ext"
	require 'byebug'

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

	# ["fca4X5EB16I:APA91bHN2GjERDv9U2Lax41ohD08b-UswoU_hkJ3MdHt6j-wSW6DCGDBYVWnrq2X8JvgxTNao1h_XDDp-KJQJObX5IjwGueMfjtEz4G3b8Y5-X6Mdht3LaTPK2P7Jx4w1QryqvBZmmyr"],

	def send_notification(registration_ids, notification, data)
		api_key = "AAAAb7b8_Ag:APA91bHGEEv6fkDh0C3tIYNufaSaQ2ouAuN8MMSZUV8nhIfVPZPfIIzNeXxU2OpOrZDv-Ynwefaxv-jTCVHP4E2ItXQeCugpKG-dLl7YLZTcy87dE9XSRDUTMigtpBKOAyWxHQXtbG43"
		headers = {
		     'Authorization' => "key=#{api_key}",
		     'Content-Type' => 'application/json'
		   }
		url = "https://fcm.googleapis.com/fcm/send"
				request = { "priority": "high",
				  "registration_ids": registration_ids,
				  "data": data
				}.to_json
		response = RestClient.post(url, request, headers)
		return 
	end

	def send_notification_without_key(registration_ids, data)
		api_key = "AAAAb7b8_Ag:APA91bHGEEv6fkDh0C3tIYNufaSaQ2ouAuN8MMSZUV8nhIfVPZPfIIzNeXxU2OpOrZDv-Ynwefaxv-jTCVHP4E2ItXQeCugpKG-dLl7YLZTcy87dE9XSRDUTMigtpBKOAyWxHQXtbG43"
		headers = {
		     'Authorization' => "key=#{api_key}",
		     'Content-Type' => 'application/json'
		   }
		url = "https://fcm.googleapis.com/fcm/send"
				request = { "priority": "high",
				  "registration_ids": registration_ids,
				  "data": data
				}.to_json
		response = RestClient.post(url, request, headers)
		puts response
		return 
	end

	def send_help
		latitude = params[:latitude]
		longitude = params[:longitude]
		registration_id = params[:registration_id]
		registration_ids = []
		FirebaseNotificationToken.all.each do |fnt|
			if fnt.registration_id != registration_id
				registration_ids << fnt.registration_id
			end
		end
		data = {
			"latitude" => latitude,
			"longitude" => longitude,
			"code" => "101"
		}
		send_notification_without_key(registration_ids, data)
		return response_data(data, "Notifications Sent", 200)	
	end
end
# def response_data(data, message, status, error:nil, disabled:false, update:false, external_rating: nil, params: {})