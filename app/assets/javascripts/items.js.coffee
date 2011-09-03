# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

window.LocalCRUD = {}

window.LocalCRUD.initGmap = (container,centerLatLng, markers) ->
  options = 
    zoom:         5
    center:       new google.maps.LatLng(centerLatLng[0], centerLatLng[1])
    zoomControl:  true
    panControl:   true
    mapTypeId:    google.maps.MapTypeId.ROADMAP
  
  map = new google.maps.Map(($ container).get(0), options)
  infoWindow = new google.maps.InfoWindow { maxWidth: 100 }
  
  for marker in markers
    loc = new google.maps.LatLng(marker.latlng[0], marker.latlng[1])
    m = new google.maps.Marker {
      position:   loc
      map:        map
      data:       marker
    }
    google.maps.event.addListener m, 'mouseover', () ->
      infoWindow.setContent("#{@data.name}<br/><a href='/items/#{@data._id}/edit'>edit item</a>")
      infoWindow.open(map, this)
    google.maps.event.addListener m, 'click', () ->
      window.location = "/items/#{@data._id}"