Rails.application.routes.draw do
  get 'game' => 'playing#game', as: :game

  get 'score' => 'playing#score', as: :score

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
