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

  def self.estimate(stop, line)
    Savon.env_namespace = :soap
    client = Savon::Client.new do
      wsdl.endpoint = 'http://www.infobustussam.com:9001/services/dinamica.asmx'
      wsdl.namespace = 'http://tempuri.org/'
      http.open_timeout = 3
      http.read_timeout = 5
    end

    response = client.request 'wsdl:GetPasoParada' do
      http.headers["SOAPAction"] = '"http://tempuri.org/GetPasoParada"'
      soap.body = {:"wsdl:linea"  => line,
                   :"wsdl:parada" => stop,
                   :"wsdl:status" => 1}
    end
    estimation = response[:get_paso_parada_response][:get_paso_parada_result][:paso_parada]

    [{:time => estimation[:e1][:minutos], :distance => estimation[:e1][:metros]},
     {:time => estimation[:e2][:minutos], :distance => estimation[:e2][:metros]}]
  rescue NoMethodError, Timeout::Error
    [{:time => nil, :distance => nil}, {:time => nil, :distance => nil}]
  end
end
