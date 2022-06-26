Rails.application.routes.draw do
  get '/projects', to: 'projects#index'
  patch '/projects/:p_id/todos/:t_id', to: 'projects#update'
  post '/todos', to: 'projects#create'
end
