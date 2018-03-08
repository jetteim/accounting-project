Rails.application.routes.draw do
  get 'images', to: 'images_detector#show'
  post 'images', to: 'images_detector#submit'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/markov', to: 'markov_text#show'
  post '/markov', to: 'markov_text#generate'
end
