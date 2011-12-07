Tussam::Application.routes.draw do
  get  "search"       => "tussam#search"
  post "estimate"     => "tussam#estimate", :as => :post_estimate
  get  "location"     => "tussam#location"
  post "stops"        => "tussam#stops"
  get  "estimate/:id" => "tussam#estimate", :as => :tussam_estimate
  root :to            => "tussam#search"
end
