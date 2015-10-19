var osm, team_map, osmUrl, curr_marker = undefined;

$(document).ready(function () {

    /**
     * Positions the tabs
     */
    function positionTabs() {
        var tabs = $('#tab-wrapper');
        if (tabs.length) {
            var nav = $('#nav');
            var search = $('#search');
            var content = $('#content');
            var offsetTop = window.pageYOffset || document.documentElement.scrollTop;

            if (offsetTop > (nav.height() + (search.is(':visible') ? search.height() : 0)) && window.innerWidth > 600) {
                tabs.addClass('fixed');
                content.css({'padding-top': (tabs.height() + parseInt(tabs.css('margin-bottom'))) + 'px'});
            }
            else {
                tabs.removeClass('fixed');
                content.css({'padding-top': 0});
            }
        }
    }

    // Scroll events
    $(window).scroll(function (e) {
        positionTabs();
    });

    // Resize events
    $(window).resize(function (e) {
        positionTabs();
    });

    // Toggle search
    $('a#toggle-search').click(function () {
        var search = $('div#search');
        search.is(":visible") ? search.slideUp() : search.slideDown(function () {
            search.find('input').focus();
        });
        return false;
    });

    /**
     * Listener para quando uma checkbox é marcada ou desmarcada
     */
    $('input:checkbox').change(
        function () {
            var select_leader = $('#select_team_leader');
            var i_value, i_text;
            //console.log(select_leader);

            var len = $("input[name='team[users][]']:checked").length;
            console.log(len);

            if (len > 0)
                $('#team-submit-form').removeClass("disabled");
            else if (len == 0)
                $('#team-submit-form').addClass("disabled");

            if ($(this).is(':checked')) {
                i_value = $(this).prop('value');
                i_text = $(this).next("label").text();

                console.log("++++++ CHECKED ++++++");
                console.log(i_value);
                console.log(i_text);

                select_leader.append($("<option/>", {
                    value: i_value,
                    text: i_text
                }));
            }
            else if (!($(this).is(':checked'))) {
                i_value = $(this).prop('value');

                console.log("------ UNCHECKED ------");
                //console.log(#select_team_leader option[value=i_value]);

                $("#select_team_leader option[value=" + i_value + "]").remove();

                //select_leader.prop("value", i_value).remove();
                //console.log(i_value);
            }
        });


    // inicializa a select box para escolher o lider
    $('select').material_select();


    // inicializa o mapa para destacar a equipa
    osmUrl = 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
    osm = L.tileLayer(osmUrl, {maxZoom: 18});
    team_map = L.map("team_map", {
        zoom: 12,
        center: [38.627881, -9.161007],
        layers: [osm],
        zoomControl: true,
        attributionControl: false
    });

    // adiciona um listener ao mapa para o evento "clique"
    team_map.on('click', onMapClick);
});

/**
 * Este método é executado quando o utilizador carrega no mapa no formulario das equipas
 * Começa por verificar se ja há marcador no mapa: se sim, remove-o.
 * A seguir cria um novo marcador no ponto em que o utilizador carregou e abre uma popup
 * com a localização (USAR GEOCODING???)
 */
function onMapClick(e) {
    // o marcador ja foi inicializado, vamos removê-lo
    if (typeof curr_marker !== "undefined")
        team_map.removeLayer(curr_marker);

    console.log(e);

    var popupContent = "<p>Localização atualizada com sucesso.<br />Nova localização: [" +
        e.latlng.lat + "; " + e.latlng.lng + "]</p>";
    curr_marker = L.marker([e.latlng.lat, e.latlng.lng]).addTo(team_map);
    curr_marker.bindPopup(popupContent).openPopup();

    var new_val = "POINT (" + e.latlng.lat + " " + e.latlng.lng + ")";
    $("#team_latlon").attr("value", new_val);
}