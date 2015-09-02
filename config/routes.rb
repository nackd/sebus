Rails.application.routes.draw do
  root :to            => "sebus#type"
  post "estimate"     => "sebus#estimate", :as => :post_estimate
  get  "estimate/:id" => "sebus#estimate", :as => :tussam_estimate
  get  "location"     => "sebus#location"
  get  "nolocation"   => "sebus#nolocation"
  post "stops"        => "sebus#stops"
  get  "about"        => "sebus#about"

  offline = Rack::Offline.configure do
    cache "/"
    cache "location"
    cache "nolocation"
    cache "about"
    public_path = Rails.root.join("public")
    Dir[public_path.join("**/*.*")].each do |file|
      cache Pathname.new(file).relative_path_from(public_path)
    end
    network "*"
  end
  match "/application.manifest" => offline, :via => :get, :as => :manifest
end
