Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/markov', to: 'markov_text#show'
  post '/markov', to: 'markov_text#generate'
end
