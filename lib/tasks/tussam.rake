namespace :tussam do
  desc 'Update stops'
  task :update_stops => :environment do
    Tussam.update_stops
  end
end
