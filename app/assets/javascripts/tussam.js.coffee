$('#location').live('pageshow',
    (event, ui) -> navigator.geolocation.getCurrentPosition(
        # success
        (pos) -> $.mobile.changePage("/stops"
                                     changeHash: false
                                     type: "post"
                                     data:
                                         lat: pos.coords.latitude
                                         lng: pos.coords.longitude
        ) # error
        (err) -> # TODO
        # options
        enableHighAccuracy: true, maximumAge: 60000, timeout: 30000
    )
)
