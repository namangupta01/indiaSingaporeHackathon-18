Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

post 'notification/set-registration-token' => 'notification#set_registraion_token'
post 'notification/send-help' => 'notification#send_help'
post 'notification/google-home' => 'notification#google_home'

end
