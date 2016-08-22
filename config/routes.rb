Rails.application.routes.draw do
  scope 'albums' do
    get '/' => 'albums#index'
    post '/' => 'albums#create'
    scope '/:id' do
      get '/' => 'albums#show'
      put '/' => 'albums#update'
      delete '/' => 'albums#destroy'
    end
  end
  scope 'photos' do
    get '/' => 'photos#index'
    post '/' => 'photos#create'
    scope '/:id' do
      get '/' => 'photos#show'
      put '/' => 'photos#update'
      delete '/' => 'photos#destroy'
    end
  end
end
