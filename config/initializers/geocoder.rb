require 'redis'
Geocoder.configure(
  lookup: :nominatim, # Use OpenStreetMap's Nominatim
  http_headers: { "User-Agent" => "rentals" },
  use_https: true
)


