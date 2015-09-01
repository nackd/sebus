require 'open-uri'

module Tussam
  def self.update_stops
    client = Savon.client do
      endpoint 'http://www.infobustussam.com:9001/services/estructura.asmx'
      namespace 'http://tempuri.org/'
      open_timeout 3
      read_timeout 5
    end

    response1 = client.call('GetLineas', soap_action: 'http://tempuri.org/GetLineas')

    stops = []
    response1.body[:get_lineas_response][:get_lineas_result][:info_linea].each do |linea|
      line = linea[:label]
      subline = linea[:sublineas][:info_sublinea][:sublinea].to_i
      response2 = client.call('GetNodosMapSublinea',
        soap_action: "http://tempuri.org/GetNodosMapSublinea",
        message: {'wsdl:label':  line,
                  'wsdl:sublinea': subline}
      )

      response2.body[:get_nodos_map_sublinea_response][:get_nodos_map_sublinea_result][:info_nodo_map].each do |node|
        number = node[:nodo].to_i
        if stop = stops.find {|s| s[:number] == number}
          stop[:lines] |= [line]
        else
          location = GeoUtm::UTM.new("30N", node[:posx].to_f, node[:posy].to_f).to_lat_lon
          stops << { :number => number,
                     :name => node[:nombre],
                     :location => [location.lat, location.lon],
                     :lines => [line]
                   }
        end
      end
    end

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

  def self.estimate(stop, line)
    client = Savon.client do
      endpoint 'http://www.infobustussam.com:9001/services/dinamica.asmx'
      namespace 'http://tempuri.org/'
      open_timeout 3
      read_timeout 5
    end

    response = client.call('GetPasoParada',
      soap_action: "http://tempuri.org/GetPasoParada",
      message: {'wsdl:linea':  line,
                'wsdl:parada': stop,
                'wsdl:status': 1}
    )
    estimation = response.body[:get_paso_parada_response][:get_paso_parada_result][:paso_parada]

    [{:time => estimation[:e1][:minutos], :distance => estimation[:e1][:metros]},
     {:time => estimation[:e2][:minutos], :distance => estimation[:e2][:metros]}]
  rescue NoMethodError, Timeout::Error
    [{:time => nil, :distance => nil}, {:time => nil, :distance => nil}]
  end
end
