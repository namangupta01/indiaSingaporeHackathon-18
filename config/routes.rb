Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

get 'notification/set-registration-token' => 'notification#set_registraion_token'


end
