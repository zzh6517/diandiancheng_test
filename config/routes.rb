Rails.application.routes.draw do
  get 'welcome/index'
  get 'welcome/show_topics'
  get 'welcome/show_comments'
  
  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
