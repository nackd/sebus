Tussam::Application.routes.draw do
  root :to            => "tussam#type"
  post "estimate"     => "tussam#estimate", :as => :post_estimate
  get  "estimate/:id" => "tussam#estimate", :as => :tussam_estimate
  get  "location"     => "tussam#location"
  get  "nolocation"   => "tussam#nolocation"
  post "stops"        => "tussam#stops"
  get  "about"        => "tussam#about"
end
