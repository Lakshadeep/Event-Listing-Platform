function initialize1()
{
var mapProp = {
  center: new google.maps.LatLng(15.0,73.0),
  zoom:5,
  mapTypeId: google.maps.MapTypeId.ROADMAP
  };

var map1 = new google.maps.Map(document.getElementById("googleMap"),mapProp);


var marker1 = new google.maps.Marker({
  position: new google.maps.LatLng(15.0,73.0),
  title:'Click to zoom',
   draggable:true
  });

marker1.setMap(map1);


google.maps.event.addListener(marker1, "click", function (event1) {

var latlng = [this.position.lat(),this.position.lng()];
op = latlng.join(',');
document.getElementById("search_key").value = op

});
}

function loadScript1()
{ 

  $("#load_map").hide();
  document.getElementById("googleMap").style.display = "";

  var script1 = document.createElement("script");
  script1.type = "text/javascript";
  script1.src = "http://maps.googleapis.com/maps/api/js?key=&sensor=false&callback=initialize1";
  document.body.appendChild(script1);
}


function initialize2()
{
var mapProp = {
  center: new google.maps.LatLng(15.0,73.0),
  zoom:5,
  mapTypeId: google.maps.MapTypeId.ROADMAP
  };

var map2 = new google.maps.Map(document.getElementById("googleMap2"),mapProp);

var marker2 = new google.maps.Marker({
  position: new google.maps.LatLng(15.0,73.0),
  title:'Click to zoom',
   draggable:true
  });


marker2.setMap(map2);

google.maps.event.addListener(marker2, "click", function (event2) {

var latlng = [this.position.lat(),this.position.lng()];
op = latlng.join(',');

document.getElementById("lat_lng").value = op
});
}

function loadScript2()
{ 
  $("#load_map_advanced").hide();
  document.getElementById("googleMap2").style.display = "";

  var script2 = document.createElement("script");
  script2.type = "text/javascript";
  script2.src = "http://maps.googleapis.com/maps/api/js?key=&sensor=false&callback=initialize2";
  document.body.appendChild(script2);
}


function show_map(lat,lng)
{
var mapProp = {
  center: new google.maps.LatLng(lat,lng),
  zoom:8,
  mapTypeId: google.maps.MapTypeId.ROADMAP
  };

var map = new google.maps.Map(document.getElementById("googleMap"),mapProp);

var marker = new google.maps.Marker({
  position: new google.maps.LatLng(lat,lng),
  title:'Click to zoom',
   draggable:true
  });

marker.setMap(map);

google.maps.event.addListener(marker, "click", function (event) {

var latlng = [this.position.lat(),this.position.lng()];
op = latlng.join(',');

});
}




