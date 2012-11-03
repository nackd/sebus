class Stop
  include Mongoid::Document
  field :location, type: Array
  index({ location: "2d" })

  def distance_to(lat, lng)
    (Geokit::LatLng.normalize(self.location).distance_to([lat, lng], :units => :kms) * 1000).to_i
  end
end
