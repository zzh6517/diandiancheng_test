Rails.application.routes.draw do
  #根路径为welcome/index页面
  root 'welcome#index'

  get 'welcome/index'
  get 'welcome/show_topics'
  get 'welcome/show_comments'

  resources :users
  resources :sessions, only: [:index, :new, :create]
end
