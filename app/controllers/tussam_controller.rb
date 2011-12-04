class TussamController < ApplicationController
  def stops
    @stops = Stop.near(location: [params[:lat].to_f, params[:lng].to_f]).limit(20)
  end

  def estimate
    @stop = Stop.where(number: params[:id].to_i).first
    @estimate = @stop.lines.inject({}){ |hash, line|
      hash.merge({line => Tussam.estimate(@stop.number, line)})
    }
  end
end
