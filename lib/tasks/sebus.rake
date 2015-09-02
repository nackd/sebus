namespace :sebus do
  desc 'Update stops'
  task :update_stops => :environment do
    Tussam.update_stops
  end
end
