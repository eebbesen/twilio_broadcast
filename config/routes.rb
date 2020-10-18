# frozen_string_literal: true

Rails.application.routes.draw do
  resources :incoming_sms
  resources :message_recipients
  resources :recipient_lists
  resources :messages
  resources :recipients
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html'

  root to: 'messages#index'

  post 'messages/:id/send_message', to: 'messages#send_message', as: :send_message
  post 'sms_status', to: 'messages#sms_status', as: :sms_status
  post 'subscribe', to: 'recipient_lists#subscribe', as: :subscribe
end
