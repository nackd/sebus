require 'open-uri'

module Tussam
  def self.update_stops
    open('http://www.infobustussam.com:9005/tussamGO/') # Need to open a session beforehand
    document = Nokogiri::XML(open('http://www.infobustussam.com:9005/tussamGO/Resultados?op=lp&ls=Todas'))

    stops = document.search('parada').collect { |parada|
      {
        :number   => parada[:numero].to_i,
        :name     => parada.at('dato#nombre').text,
        :location => [parada[:lat].to_f, parada[:lng].to_f],
        :lines    => parada.search('linea').collect(&:text)
      }
    }

    if stops.size > 0
      Stop.delete_all
      stops.each do |stop|
        Stop.create! stop
      end
    end
  end

  def self.update_stops_if_empty
    update_stops if Stop.count == 0
  end
end
