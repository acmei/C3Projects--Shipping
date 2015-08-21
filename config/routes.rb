Rails.application.routes.draw do
  get "/quote" => "fed_ax_api#quote"
  post "/ship" => "fed_ax_api#ship"
  root "fed_ax_api#root"
end
