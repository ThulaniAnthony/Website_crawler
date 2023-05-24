Rails.application.routes.draw do
  root 'crawlers#index'
  post '/crawl', to: 'crawlers#crawl'
  resources :crawlers, only: [:index, :crawl]

end
