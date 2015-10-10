var map, create_team_map, edit_team_map, osmUrl, osmAttrib, osm, osm2;
var map_to_init;

$(document).ready(function () {
    // DOM ready
    //var vheight = ($('#curr_location').children().width()) - 400;
    ////var vheight = 300;
    //console.log(vheight);
    //var myFn = function () {
    //    $('#curr_location').children().animate({'margin-left': '-=' + vheight}, 10000, function () {
    //        $('#curr_location').children().animate({'margin-left': '+=' + vheight}, 300);
    //    });
    //};
    //
    //myFn();
    //setInterval(myFn, 10300);

    // cria uma imagem com a inicial do nome do utilizador autenticado
    $('.profile_name').initial({
        name: 'Name', // Name of the user
        charCount: 1, // Number of characherts to be shown in the picture.
        textColor: '#ffffff', // Color of the text
        seed: 0, // randomize background color
        height: 40,
        width: 40,
        fontSize: 20,
        fontWeight: 400,
        fontFamily: 'HelveticaNeue-Light,Helvetica Neue Light,Helvetica Neue,Helvetica, Arial,Lucida Grande, sans-serif',
        radius: 25
    });

    $('.modal-trigger').leanModal();

    //altera o background da lista das equipas quando o utilizador faz hover com o rato
    $("#hover_test div:first-child")
        .mouseenter(function () {
            if (!($(this).hasClass("active")))
                $(this).css("background", "#eaeaea")
        })
        .mouseleave(function () {
            if (!($(this).hasClass("active")))
                $(this).css("background", "#fff")
        });

    //faz mais ou menos o mesmo mas quando o utilizador clica numa entrada da lista
    $("div.collapsible-header").click(function (div) {
        $("div.collapsible-header").css("background", "#fff");
        $("div.collapsible-header.active").css("background", "#eaeaea");
    });

    osmUrl = 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
    osmAttrib = '&copy; <a href="http://openstreetmap.org/copyright">OpenStreetMap</a> contributors';
    osm = L.tileLayer(osmUrl, {maxZoom: 20, attribution: osmAttrib});

    /* mapa principal */
    map = L.map("map", {
        zoom: 12,
        center: [38.627881, -9.161007],
        layers: [osm],
        zoomControl: false,
        attributionControl: true
    });

    var sidebar = L.control.sidebar('sidebar', {position: 'right'}).addTo(map);

    var drawnItems = new L.FeatureGroup();
    map.addLayer(drawnItems);

    L.drawLocal.draw.toolbar.buttons.polygon = 'Desenhar um poligono';
    L.drawLocal.draw.toolbar.buttons.polyline = 'Desenhar uma linha poligonal';
    L.drawLocal.draw.toolbar.buttons.marker = 'Desenhar um marcador';
    L.drawLocal.draw.toolbar.buttons.rectangle = 'Desenhar um rectangulo';
    L.drawLocal.draw.toolbar.buttons.circle = 'Desenhar um circulo';
    var drawControl = new L.Control.Draw({
        position: 'bottomleft',
        draw: {
            polygon: {
                title: 'Pol�gono',
                allowIntersection: true,
                drawError: {
                    color: '#b00b00',
                    timeout: 1000
                },
                shapeOptions: {
                    color: '#bada55'
                },
                showArea: true
            },
            polyline: {
                metric: false
            },
            circle: {
                shapeOptions: {
                    color: '#662d91'
                }
            },
            //rectangle: false //� assim que se desativam op��es
        },
        edit: {
            featureGroup: drawnItems
        }
    });
    map.addControl(drawControl);

    /* GPS enabled geolocation control set to follow the user's location */
    new L.control.locate({
        position: "bottomright",
        drawCircle: true,
        follow: true,
        setView: true,
        keepCurrentZoomLevel: false,
        markerStyle: {
            weight: 1,
            opacity: 0.8,
            fillOpacity: 0.8
        },
        circleStyle: {
            weight: 1,
            clickable: false
        },
        icon: "fa fa-location-arrow",
        metric: true,
        strings: {
            title: "Show my location",
            popup: "You are within {distance} {unit} from this point",
            outsideMapBoundsMsg: "You seem located outside the boundaries of the map"
        },
        locateOptions: {
            maxZoom: 20,
            watch: true,
            enableHighAccuracy: true,
            maximumAge: 10000,
            timeout: 10000
        }
    }).addTo(map);

    /* controlo do zoom do mapa  */
    new L.Control.Zoom({position: 'bottomright'}).addTo(map);

    /* listener invocado quando � criada uma feature */
    map.on('draw:created', function (e) {
        var type = e.layerType,
            layer = e.layer;

        if (type === 'marker') {
            layer.bindPopup('Placeholder text!');
        }

        drawnItems.addLayer(layer);
    });

    /* listener invocado quando se edita uma feature */
    map.on('draw:edited', function (e) {
        var layers = e.layers;
        layers.eachLayer(function (layer) {
            //do whatever you want, most likely save back to db
        });
    });

    // inicializa as dropdowns que existem na pagina!
    $('select').material_select();
});

/*
 * workaround para inicializar o mapa correspondente,
 * uma vez que se o mapa do modal fosse inicializado no document.ready,
 * como a largura do modal � inexistente, o mapa fica com tamanho bastante reduzido e
 * s� ficava correcto com o resize do viewport
 */
function initMap() {
    osm2 = L.tileLayer(osmUrl, {maxZoom: 18});

    if (map_to_init == 1) {
        //alert("criar equipa");
        /* mapa apresentado na modal para criar equipa */
        create_team_map = L.map("create_team_map", {
            zoom: 12,
            center: [38.627881, -9.161007],
            layers: [osm2],
            zoomControl: true,
            attributionControl: false
        });
    }
    else if (map_to_init == 2) {
        //alert("editar equipa");
        /* mapa apresentado na modal para editar equipa */
        create_team_map = L.map("edit_team_map", {
            zoom: 12,
            center: [38.627881, -9.161007],
            layers: [osm2],
            zoomControl: true,
            attributionControl: false
        });
    }
    map_to_init = -1;
}

/*
 * o parametro indica se estamos a editar ou a criar uma equipa nova
 * dps verifica se o mapa ja esta desenhado ou se � necessario inicializar
 */
function drawMapOnModal(number) {
    if (number == 1) {
        if (typeof create_team_map === "undefined") {
            map_to_init = number;
            setTimeout(initMap, 500);
        }
    }
    else if (number == 2) {
        if (typeof edit_team_map === "undefined") {
            map_to_init = number;
            setTimeout(initMap, 500);
        }
    }
}


//$(window).resize(function () {
//
//});

//$(document).on("mouseover", ".feature-row", function (e) {
//    //highlight.clearLayers().addLayer(L.circleMarker([$(this).attr("lat"), $(this).attr("lng")], highlightStyle));
//});
