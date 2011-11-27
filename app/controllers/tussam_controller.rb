class TussamController < ApplicationController
  def index
  end

  def estimate
    Savon.env_namespace = :soap
    client = Savon::Client.new do
      wsdl.endpoint = 'http://www.infobustussam.com:9001/services/dinamica.asmx'
      wsdl.namespace = 'http://tempuri.org/'
      http.open_timeout = 3
      http.read_timeout = 5
    end

    response = client.request 'wsdl:GetPasoParada' do
      http.headers["SOAPAction"] = '"http://tempuri.org/GetPasoParada"'
      soap.body = {:"wsdl:linea" => params[:estimate][:line],
                   :"wsdl:parada" => params[:estimate][:stop],
                   :"wsdl:status" => 1}
    end

    estimation = response[:get_paso_parada_response][:get_paso_parada_result][:paso_parada]
    @e1 = estimation[:e1][:minutos]
    @e2 = estimation[:e2][:minutos]
  end
end
