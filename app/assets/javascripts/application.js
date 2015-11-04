// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery2
//= require jquery_ujs
//= require turbolinks
//= require materialize-sprockets
//= require leaflet
//= require leaflet-sidebar
//= require leaflet.groupedlayercontrol.min
//= require leaflet.draw-touch
//= require L.Control.Locate.min
//= require leaflet.markercluster
//= require leaflet.ajax.min
//= require initial


//var team_source;
//var geo_source;
//var user_source;
var source;

if (!!window.EventSource) {
    //team_source = new EventSource("/team_update");
    //geo_source = new EventSource("/geo_entity_update");
    //user_source = new EventSource("/user_update");
    source = new EventSource("/entity_updates");
} else {
    // Result to xhr polling :(
}

source.addEventListener('entity_updates', function(e) {
    console.log("UPDATES DA CENA!!!!!!\n" + e.data);
    //source.close();
}, false);


//team_source.addEventListener('team_update', function(e) {
//    console.log("UPDATES DA EQUIPA!!!\n" + e.data);
//    //source.close();
//}, false);
//
//geo_source.addEventListener('geo_entity_update', function(e) {
//    console.log("UPDATES DAS ENTIDADES!!!\n" + e.data);
//    //source.close();
//}, false);
//
//user_source.addEventListener('user_update', function(e) {
//    console.log("UPDATES DO UTILIZADOR!!!\n" + e.data);
//    //source.close();
//}, false);