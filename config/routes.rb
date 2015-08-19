Rails.application.routes.draw do
  get "/quote" => "fed_ax_api#quote"
  post "/ship" => "fed_ax_api#ship"
end
