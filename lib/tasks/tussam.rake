namespace :tussam do
  task :update_stops => :environment do
    Tussam.update_stops
  end
end
