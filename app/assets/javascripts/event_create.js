function initialize()
{
var mapProp = {
  center: new google.maps.LatLng(15.0,73.0),
  zoom:5,
  mapTypeId: google.maps.MapTypeId.ROADMAP
  };
var map = new google.maps.Map(document.getElementById("googleMap"),mapProp);

var marker = new google.maps.Marker({
  position: new google.maps.LatLng(15.0,73.0),
  title:'Click to zoom',
   draggable:true
  });
marker.setMap(map);
google.maps.event.addListener(marker, "click", function (event) {
var lat = this.position.lat();
var lng = this.position.lng();
document.getElementById("latitude").value = lat;
document.getElementById("longitude").value = lng;
});

}
function loadScript()
{ 
  var script = document.createElement("script");
  script.type = "text/javascript";

  $("#mapbutton").hide();
  document.getElementById("mapdisp").style.display = "";

  script.src = "http://maps.googleapis.com/maps/api/js?key=&sensor=false&callback=initialize";
  document.body.appendChild(script);
}