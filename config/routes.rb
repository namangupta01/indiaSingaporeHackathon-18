Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

post 'notification/set-registration-token' => 'notification#set_registraion_token'
post 'notification/send-help' => 'notification#send_help'
post 'notification/google-action' => 'notification#google_home'
post 'notification/upload-image-notification' => 'notification#upload_unknown_image_send_notification'
get 'notification/get-notifications' => 'notification#get_notifications'
post 'notification/fighting-notification' => 'notification#fighting_notification'

end
