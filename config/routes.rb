Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/', to: 'game#welcome', as: 'welcome'
  get '/game/single_player', to: 'game#single_player'
  get '/game/vsmode', to: 'game#vsmode'
  get '/game/menu', to: 'game#menu'
  post '/game/vsdata', to: 'game#vsdata'
  get '/game/vsmenu1', to: 'game#vsmenu1'
  get '/game/vsmenu2', to: 'game#vsmenu2'
  get '/game/pass', to: 'game#pass'
  post '/game/end_turn', to: 'game#end_turn', as: 'end_turn'
  get '/game/notifications', to: 'game#notifications', as: 'notifications'
  get '/game/loss', to: 'game#loss', as: 'loss'
  get '/game/instructions', to: 'game#instructions'
  get '/game/under_construction', to: 'game#under_construction'

  get '/intro/start', to: 'intro#start'
  get '/intro/onea', to: 'intro#onea'
  get '/intro/oneb', to: 'intro#oneb'
  patch '/intro/cg_update', to: 'intro#cg_update', as: 'sp_name'
  get '/intro/second', to: 'intro#second'
  get '/intro/twoa', to: 'intro#twoa'
  get '/intro/twob', to: 'intro#twob'
  get '/intro/threea', to: 'intro#threea'
  get '/intro/threeb', to: 'intro#threeb'
  get '/intro/foura', to: 'intro#foura'
  get '/intro/fourb', to: 'intro#fourb'

  resources :dragons, only: [:new, :index, :create]
  resources :villages, only: [:index]

  resources :raids, only: [:new, :create]
  get 'raids/:id/select_dragons', to: 'raids#select_dragons', as: 'select_dragons'
  post 'raids/:id/pairing', to: 'raids#pairing', as: 'pairing'
  get 'raids/:id/roll_dice', to: 'raids#roll_dice', as: 'roll_dice'
  get 'raids/:id/result', to: 'raids#result', as: 'result'

  get 'villages/:id/attack', to: 'villages#attack', as: 'attack'
  get 'villages/:id/defend', to: 'villages#defend', as: 'defend'

end
