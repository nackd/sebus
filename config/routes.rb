Tussam::Application.routes.draw do
  root :to            => "tussam#type"
  post "estimate"     => "tussam#estimate", :as => :post_estimate
  get  "estimate/:id" => "tussam#estimate", :as => :tussam_estimate
  get  "location"     => "tussam#location"
  get  "nolocation"   => "tussam#nolocation"
  post "stops"        => "tussam#stops"
  get  "about"        => "tussam#about"

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
  match "/application.manifest" => offline, :as => :manifest
end
