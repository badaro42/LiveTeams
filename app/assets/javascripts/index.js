var map, osmUrl, osmAttrib, osm;

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
    osm = L.tileLayer(osmUrl, {maxZoom: 20});

    /* mapa principal */
    map = L.map("map", {
        zoom: 12,
        center: [38.627881, -9.161007],
        layers: [osm],
        zoomControl: false,
        attributionControl: false
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
                title: 'Polígono',
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
            //rectangle: false //é assim que se desativam opções
        },
        edit: {
            featureGroup: drawnItems
        }
    });
    map.addControl(drawControl);

    /* GPS enabled geolocation control set to follow the user's location */
    new L.control.locate({
        position: "bottomleft",
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
            title: "Clique aqui para ativar a geolocalização",
            popup: "Encontra-se a {distance} {unit} deste ponto",
            outsideMapBoundsMsg: "Parece que se encontra fora dos limites do mapa"
        },
        locateOptions: {
            maxZoom: 19,
            watch: true,
            enableHighAccuracy: true,
            maximumAge: 10000,
            timeout: 10000
        }
    }).addTo(map);

    /* controlo do zoom do mapa  */
    new L.Control.Zoom({position: 'bottomleft'}).addTo(map);

    /* listener invocado quando é criada uma feature */
    map.on('draw:created', function (e) {
        console.log(e);
        var name = "", desc = "", coords = "", user_id = "",
            radius = 0, type = e.layerType, layer = e.layer;

        if (type === 'marker') {
            layer.bindPopup('NOVO MARCADOR!');

            console.log(e.layer._latlng);
            console.log(e.layer._latlng.lat);
            console.log(e.layer._latlng.lng);

            coords = "POINT(" + e.layer._latlng.lng + " " + e.layer._latlng.lat + ")";
            desc = "ADICIONADO ATRAVES DO MAPA";
            name = "Marcador porreiro";
            radius = 0;
        }
        else if (type === 'circle') {
            layer.bindPopup('NOVO CIRCULO!');
            console.log(e.layer._latlng);
        }
        else if (type === 'polyline') {
            layer.bindPopup('NOVA LINHA POLIGONAL!');
            console.log(e.layer._latlngs);
        }
        else if (type === 'rectangle') {
            layer.bindPopup('NOVO RECTANGULO!');
            console.log(e.layer._latlngs);
        }
        else if (type === 'polygon') {
            layer.bindPopup('NOVO POLIGONO!');
            console.log(e.layer._latlngs);
        }

        $.ajax({
            type: "POST",
            url: "/geo_entities",
            dataType: "json",
            data: {
                geo_entity: {
                    name: name,
                    entity_type: type,
                    radius: radius,
                    description: desc,
                    latlng: coords,
                    user_id: "1"
                }
            },
            success: function (data) {
                console.log("MARCADOR ADICIONADO COM SUCESSO");
            },
            error: function (err) {
                console.log("erro a adicionar o marcador");
                console.log(err);
            }
        });

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


    var team_icon = L.icon({
        iconUrl: 'http://freeflaticons.net/wp-content/uploads/2014/11/group-copy-1416476921gn4k8.png',
        //shadowUrl: 'leaf-shadow.png',

        iconSize: [38, 38], // size of the icon
        //shadowSize:   [50, 64], // size of the shadow
        iconAnchor: [19, 30], // point of the icon which will correspond to marker's location
        //shadowAnchor: [4, 62],  // the same for the shadow
        popupAnchor: [-1, -30] // point from which the popup should open relative to the iconAnchor
    });


    var geojson = "";
    // retorna todas as entidades que estao na BD
    $.ajax({
        type: "GET",
        url: '/get_geo_entities',
        dataType: 'json',
        success: function (data) {
            console.log(data);
            L.geoJson(data, {
                pointToLayer: function (feature, latlng) {
                    return L.marker(latlng);
                },
                onEachFeature: function (feature, layer) {
                    popupOptions = {maxWidth: 600};
                    //layer.bindLabel('<h4>' + feature.properties.name + '</h4>');
                    //sidebar.setContent('<h4>'+feature.properties.musno+'</h4><br>'+'<h4>'+feature.properties.exchange_name+'</h4><br>'+feature.properties.pcp, popupOptions);
                    layer.bindPopup('<p>' + feature.properties.name + '</p>' +
                        '<p>' + feature.properties.desc + '</p>', popupOptions);
                }
            }).addTo(map);
        },

        //geojson.addTo(map);
        //console.log(geojson);
        error: function (err) {
            console.log(err);
        }
    });


    $.getJSON("/teams", function (json) {
        var i, item, popup_content, coords_arr, marker;
        for (i = 0; i < json.length; i++) {
            item = json[i];
            console.log(item);

            if (item.latlon != null) {
                coords_arr = parsePointCoordinates(item.latlon);

                popup_content = "<p>" + item.name + "<br/>Latitude:" +
                    coords_arr[0] + "<br/> Longitude:" + coords_arr[1] + "</p>";
                marker = L.marker([coords_arr[0], coords_arr[1]], {icon: team_icon}).addTo(map);
                marker.bindPopup(popup_content);
            }
        }
    });
})
;


// o parametro "coords" é da forma -> "POINT(33.333 11.111)"
// retorna um vector com 2 posiçoes, uma para cada coordenada
function parsePointCoordinates(coords) {
    var split_res = coords.split("(");
    var new_split_res = split_res[1].split(" ");

    var res = [];
    res.push(new_split_res[0]); //latitude
    res.push(new_split_res[1].split(")")[0]); //longitude

    return res;
}

/*
 * workaround para inicializar o mapa correspondente,
 * uma vez que se o mapa do modal fosse inicializado no document.ready,
 * como a largura do modal é inexistente, o mapa fica com tamanho bastante reduzido e
 * só ficava correcto com o resize do viewport
 */
//function initMap() {
//    osm2 = L.tileLayer(osmUrl, {maxZoom: 18});
//
//    if (map_to_init == 1) {
//        //alert("criar equipa");
//        /* mapa apresentado na modal para criar equipa */
//        create_team_map = L.map("create_team_map", {
//            zoom: 12,
//            center: [38.627881, -9.161007],
//            layers: [osm2],
//            zoomControl: true,
//            attributionControl: false
//        });
//    }
//    else if (map_to_init == 2) {
//        //alert("editar equipa");
//        /* mapa apresentado na modal para editar equipa */
//        create_team_map = L.map("edit_team_map", {
//            zoom: 12,
//            center: [38.627881, -9.161007],
//            layers: [osm2],
//            zoomControl: true,
//            attributionControl: false
//        });
//    }
//    map_to_init = -1;
//}

/*
 * o parametro indica se estamos a editar ou a criar uma equipa nova
 * dps verifica se o mapa ja esta desenhado ou se é necessario inicializar
 */
//function drawMapOnModal(number) {
//    if (number == 1) {
//        if (typeof create_team_map === "undefined") {
//            map_to_init = number;
//            setTimeout(initMap, 500);
//        }
//    }
//    else if (number == 2) {
//        if (typeof edit_team_map === "undefined") {
//            map_to_init = number;
//            setTimeout(initMap, 500);
//        }
//    }
//}


//$(window).resize(function () {
//
//});

//$(document).on("mouseover", ".feature-row", function (e) {
//    //highlight.clearLayers().addLayer(L.circleMarker([$(this).attr("lat"), $(this).attr("lng")], highlightStyle));
//});
