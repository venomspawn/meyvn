# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'events/index_page#draw'

  scope module: 'users' do
    post 'users'       => 'creation#create'
    get  'users/new'   => 'new_page#draw'
    get  'login'       => 'login_page#draw'
    post 'login'       => 'login#login'
    post 'logout'      => 'logout#logout'
    post 'save_filter' => 'filter_saving#save'
  end

  scope module: 'events' do
    post 'events'        => 'creation#create'
    get  'events'        => 'index_page#draw'
    get  'events/new'    => 'new_page#draw'
    get  'events/stream' => 'stream#stream'
  end
end
