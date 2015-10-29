var map, osmUrl, osmAttrib, osm, sidebar, cluster, drawnItems;
var e_type, e_radius, e_coords, coords_to_display, e_length, e_area, e_layer, e_num_points;

$(document).ready(function () {
    sidebar = L.control.sidebar('sidebar', {position: 'right'}).addTo(map);
    cluster = L.markerClusterGroup();

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

    drawnItems = new L.FeatureGroup();
    map.addLayer(drawnItems);

    /* controlo do zoom do mapa  */
    new L.Control.Zoom({position: 'bottomleft'}).addTo(map);

    // cria a barra de controlos para a criação de entidades
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

    // Geolocalização do utilizador através do GPS
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
        fontFamily: 'Helvetica Neue-Light,Helvetica Neue Light,Helvetica Neue,Helvetica, Arial, Lucida Grande, sans-serif',
        radius: 25
    });

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

    // inicializa as dropdowns que existem na pagina!
    $('select').material_select();

    var team_icon = L.icon({
        iconUrl: 'http://freeflaticons.net/wp-content/uploads/2014/11/group-copy-1416476921gn4k8.png',
        iconSize: [38, 38], // size of the icon
        iconAnchor: [19, 30], // point of the icon which will correspond to marker's location
        popupAnchor: [-1, -30] // point from which the popup should open relative to the iconAnchor
    });


    // ****************** CHAMADAS ASSINCRONAS PARA POPULAR O MAPA ******************

    // retorna todas as entidades que estao na BD
    var geo_entities = new L.GeoJSON.AJAX("/get_geo_entities.json", {
        pointToLayer: function (feature, latlng) {
            console.log(feature);
            if (feature.properties.radius > 0)
                return L.circle(latlng, feature.properties.radius);
            else
                return L.marker(latlng);
        },
        onEachFeature: function (feature, layer) {
            layer.bindPopup('<p>' + feature.properties.name + '</p>' +
                '<p>' + feature.properties.description + '</p>');
        }
    });

    var teams_json = new L.GeoJSON.AJAX("/teams/teams_to_json.json", {
        pointToLayer: function (feature, latlng) {
            console.log(feature);
            return L.marker(latlng, {icon: team_icon});
        },
        onEachFeature: function (feature, layer) {
            layer.bindPopup('<p>' + feature.properties.name + '</p>' +
                '<p>' + feature.geometry.coordinates + '</p>');
        }
    });

    // listener invocado quando a chamada ajax das entidades terminar!
    geo_entities.on('data:loaded', function () {
        console.log("finish");
        cluster.addLayer(geo_entities);
        map.addLayer(cluster);
    });

    geo_entities.on('data:error', function (err) {
        console.log(err);
    });

    // listener invocado quando a chamada ajax das equipas terminar!
    teams_json.on('data:loaded', function () {
        console.log("finish");
        cluster.addLayer(teams_json);
        map.addLayer(cluster);
    });

    teams_json.on('data:error', function (err) {
        console.log(err);
    });



    // ****************** LISTENERS PARA A CRIAÇÃO/EDIÇÃO DE ENTIDADES ******************

    /* listener invocado quando é criada uma feature */
    map.on('draw:created', function (e) {
        console.log(e);
        e_type = e.layerType;
        e_layer = e.layer;
        e_num_points = 1;

        if (e_type === 'marker' || e_type === 'circle') {
            $("#e_area_div").prop('hidden', true);
            $("#e_length_div").prop('hidden', true);
            $("#e_num_points_div").prop('hidden', true);

            if (e_type === 'circle') {
                e_radius = e_layer.getRadius();
                $('#e_type_div').removeClass('s4 s12').addClass('s6');
                $("#e_radius_div").prop('hidden', false);
                $('#e_radius').text(Math.round(e_radius));
                $('#e_type').text("Circulo");
            }
            else {
                e_radius = 0;
                $('#e_type_div').removeClass('s4 s6').addClass('s12');
                $("#e_radius_div").prop('hidden', true);
                $('#e_type').text("Marcador");
            }

            $('#e_coords').val(e_layer.getLatLng());
            $('#e_coords').trigger('autoresize');
            $('#e_coords_div label').addClass('active');

            e_layer.bindPopup('NOVO ' + e_type + '!');
            console.log(e_layer);
            e_coords = "POINT(" + e_layer.getLatLng().lng + " " + e_layer.getLatLng().lat + ")";
        }
        else if (e_type === 'polyline' || e_type === 'rectangle' || e_type === 'polygon') {
            e_radius = 0;
            e_num_points = e_layer.getLatLngs().length;

            $("#e_radius_div").prop('hidden', true);
            $("#e_num_points_div").prop('hidden', false);
            $('#e_num_points').text(e_num_points);

            if (e_type === 'polyline') {
                e_coords = "LINESTRING(";

                $('#e_type_div').removeClass('s6 s12').addClass('s4');
                $("#e_area_div").prop('hidden', true);
                $('#e_type').text("Linha Poligonal");
            }
            else {
                if (e_type === 'rectangle')
                    $('#e_type').text("Rectangulo");
                else
                    $('#e_type').text("Poligono");

                e_coords = "POLYGON((";
                e_area = L.GeometryUtil.geodesicArea(e_layer.getLatLngs());
                e_area = (Math.round(e_area) / 100000) + "";
                e_area = e_area.replace(".", ",");

                $('#e_type_div').removeClass('s6 s12').addClass('s4');
                $("#e_length_div").prop('hidden', true);
                $("#e_area_div").prop('hidden', false);
                $('#e_area').text(e_area);
            }

            e_layer.bindPopup('NOVO ' + e_type + '!');
            console.log(e_layer.getLatLngs());

            var temp_point = null;
            var c_arr = e_layer.getLatLngs();
            coords_to_display = "";
            e_length = 0;
            $.each(c_arr, function (i, curr_point) {
                coords_to_display += curr_point;
                if (e_type === 'polyline') {
                    if (temp_point == null)
                        temp_point = curr_point;
                    else {
                        e_length += temp_point.distanceTo(curr_point);
                        temp_point = curr_point;
                    }
                }
                e_coords += curr_point.lng + " " + curr_point.lat;
                if (i < c_arr.length - 1) {
                    e_coords += ",";
                    coords_to_display += "\n";
                }
            });

            $('#e_coords').val(coords_to_display);
            $('#e_coords').trigger('autoresize');
            $('#e_coords_div label').addClass('active');

            e_length = (Math.round(e_length) / 1000) + "";
            e_length = e_length.replace(".", ",");
            if (e_type === 'polyline') {
                e_coords += ")";
                $("#e_length_div").prop('hidden', false);
                $('#e_length').text(e_length);
            }
            else
                e_coords += "))";
        }
        $('#confirm_entity_creation').openModal();
    });

    /* listener invocado quando se edita uma feature */
    //map.on('draw:edited', function (e) {
    //    var layers = e.layers;
    //    layers.eachLayer(function (layer) {
    //        //do whatever you want, most likely save back to db
    //    });
    //});
});

//$(document).keyup(function(e) {
//    //if (e.keyCode == 13) $('.save').click();     // enter
//    if (e.keyCode == 27) { // esc
//        if(modal_is_open) {
//            drawnItems.removeLayer(e_layer);
//            modal_is_open = false;
//        }
//    }
//});


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

// envia a entidade criada para a Base de Dados
function insertGeoEntity() {
    modal_is_open = false;
    console.log("inserir nova entidaade");

    var name = $('#e_name').val();
    var description = $('#e_description').val();

    console.log("***** PROPRIEDADES DA ENTIDADE *****");
    console.log("nome: " + name);
    console.log("tipo: " + e_type);
    console.log("raio: " + e_radius);
    console.log("descrição: " + description);
    console.log("coordenadas: " + e_coords);
    console.log("************************************");

    $.ajax({
        type: "POST",
        url: "/geo_entities",
        dataType: "json",
        data: {
            geo_entity: {
                name: name,
                entity_type: e_type,
                radius: e_radius,
                description: description,
                latlon: e_coords
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

    drawnItems.addLayer(e_layer);
    e_layer = null;
}