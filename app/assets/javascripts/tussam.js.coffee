$(document).bind('mobileinit', ->
    $.mobile.loader.prototype.options.text = "cargando"
    $.mobile.loader.prototype.options.textVisible = true
    $.mobile.pageLoadErrorMessage = "No se pudo cargar la página"
)

$('#location').live('pageshow', (event, ui) ->
    if navigator.geolocation
        navigator.geolocation.getCurrentPosition(
            # success
            (pos) -> $.mobile.changePage("/stops"
                                         changeHash: false
                                         type: "post"
                                         data:
                                             lat: pos.coords.latitude
                                             lng: pos.coords.longitude
            ) # error
            (err) -> $.mobile.changePage "/nolocation"
            # options
            enableHighAccuracy: true, maximumAge: 60000, timeout: 30000
        )
    else
        $.mobile.changePage "/nolocation"
)
