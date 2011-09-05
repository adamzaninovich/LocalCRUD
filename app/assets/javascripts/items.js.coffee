# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.LocalCRUD = {}

window.LocalCRUD.initGmap = (container, centerLatLng, markers, zoom=5, draggable=true) ->
  options = 
    zoom:               zoom
    center:             new google.maps.LatLng(centerLatLng[0], centerLatLng[1])
    zoomControl:        true
    panControl:         false
    streetViewControl:  false
    mapTypeId:          google.maps.MapTypeId.ROADMAP
    draggable:          draggable
    mapTypeControl:     false
  
  map = new google.maps.Map(($ container).get(0), options)
  infoWindow = new google.maps.InfoWindow { maxWidth: 100 }
  
  if markers isnt undefined
    for marker in markers
      loc = new google.maps.LatLng(marker.coordinates.lat, marker.coordinates.lng)
      m = new google.maps.Marker {
        position:   loc
        map:        map
        data:       marker
      }
      google.maps.event.addListener m, 'mouseover', () ->
        infoWindow.setTitle("#{@data.name}")
        infoWindow.open(map, this)
      google.maps.event.addListener m, 'click', () ->
        window.location = "/items/#{@data._id}"
  
  return map