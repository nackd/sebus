require 'tussam'

Rails.configuration.after_initialize do
  Tussam.update_stops_if_empty
end
