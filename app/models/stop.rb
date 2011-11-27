class Stop
  include Mongoid::Document
  field :location, type: Array
  index [[ :location, Mongo::GEO2D ]]
end
