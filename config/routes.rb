Rails.application.routes.draw do
  
  resources :uploads
  
  match '/merge_audio', to: "uploads#merge_audio", via: :get
  
end
