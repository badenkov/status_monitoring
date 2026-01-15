Rails.application.routes.draw do
  root to: redirect("/monitored_endpoints")

  resources :monitored_endpoints do
    resources :daily_details, only: %i[ show ], param: :date, module: :monitored_endpoints
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
