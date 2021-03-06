class NotificationController < ApplicationController
	protect_from_forgery with: :null_session
	require 'active_support'
	require "active_support/core_ext"


	def fighting_notification
		is_fighting = params[:is_fighting]
		data = {
			"notification_type" => 2,
			"is_fighting" => true,
			"latitude" => 1.3512422,
			"longitude" => 103.6879233 
		}
		registration_ids = []
		FirebaseNotificationToken.all.each do |fnt|
			registration_ids << fnt.registration_id
		end

		send_notification_without_key(registration_ids, data)
		return response_data({}, "Notifications Sent" , 200)
	end


	def google_home
		# response = Hash.new
		# response[:speech] = "asd1"
		# response[:displayText] = "asd2"
		# response[:data][:google][:expect_user_response] = true
		# response[:data][:google][:is_ssml] = true
		# response[:data][:google][:permissions_request][:opt_context] = "opt_context"
		# response[:data][:google][:permissions] = ["DEVICE_PRECISE_LOCATION"]
		# response[:contextOut] = ["contextOut"]
		# response = {
		# 	  "speech": "asd1",
		# 	  "displayText": "asd2",
		# 	  "data": {
		# 	    "google": {
		# 	      "expect_user_response": true,
		# 	      "is_ssml": true,
		# 	      "permissions_request": {
		# 	        "opt_context": "context",
		# 	        "permissions": [
		# 	          "DEVICE_PRECISE_LOCATION"
		# 	        ]
		# 	      }
		# 	    }
		# 	  }
		# 	}
		# response[:text] = "text"
		# render json: response
		registration_ids = []
		FirebaseNotificationToken.all.each do |fnt|
			registration_ids << fnt.registration_id
		end
		data = {
			"notification_type" => 3,
			"latitude" => 1.3512422,
			"longitude" => 103.6879233
		}
		send_notification_without_key(registration_ids, data)
		return response_data(data, "Notifications Sent", 200)

	end

	def set_registraion_token
		reg_type = params["reg_type"]
		registration_id = params["registration_id"]
		if registration_id.blank?
			return response_data({}, "No Registration Id", 404)
		else
			fnt = FirebaseNotificationToken.where(registration_id: registration_id)
			unless fnt.any?
				fnt = FirebaseNotificationToken.create(registration_id: registration_id, reg_type: reg_type)
				fnt.save!
				return response_data(fnt, "Token Created", 200)	
			else
				fnt = fnt.first
				fnt.reg_type = reg_type
				fnt.save!
				return response_data(fnt, "Updated", 200)	
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
		notification = Notification.new
		notification.data = data.to_json
		notification.save!
		data['notification_id'] = notification.id
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
			"notification_type" => 0,
			"latitude" => latitude,
			"longitude" => longitude,
			"code" => "101"
		}
		send_notification_without_key(registration_ids, data)
		return response_data(data, "Notifications Sent", 200)
	end

	def upload_unknown_image_send_notification
		image = params[:image]
		name = SecureRandom.hex + "." + image.original_filename.split(".")[1]
		File.open(Rails.root.join('public','uploads',name),'wb') do |file|
			file.write(image.read)
		end
		registration_ids = []
		FirebaseNotificationToken.all.each do |fnt|
			if fnt.reg_type == 'security'
				registration_ids << fnt.registration_id
			end
		end
		data = {
			'reg_type' => 'security',
			'notification_type' => 1,
			'image_link' => "/uploads/#{name}",
			'code' => "101"
		}
		send_notification_without_key(registration_ids, data)
		return response_data({}, "Notifications Sent To Security", 200)	
	end

	def get_notifications
		notifications = []
		Notification.all.each do |notification|
			noty = {}
			noty[:id] = notification.id
			noty[:data] = JSON.parse(notification.data)
			noty[:data][:created_at] = notification.created_at
			notifications << noty
		end
		response_data(notifications, "List of all Notifications", 200)	
	end

	def set_help_user
		notification_id = params[:notification_id]
		user = params[:user]
		notification = Notification.where(id: notification_id)
		if notification.any?
			noty_user_mapping = NotificationUserMapping.new
			noty_user_mapping.notification_id = notification_id
			noty_user_mapping.user = user
			noty_user_mapping.save!
			return response_data(noty_user_mapping, "List of all Notifications", 200)	
		else
			return response_data({}, "Not able to create. Invalid notification id", 200)	
		end
	end

	def get_all_notification_mapping
		notification_id = params[:notification_id]
		noty_user_mappings = NotificationUserMapping.where(notification_id: notification_id)
		return response_data(noty_user_mappings, "List of notification user mappings", 200)
	end
end
# def response_data(data, message, status, error:nil, disabled:false, update:false, external_rating: nil, params: {})