// documento carregado na pagina de login/registo

// coordenadas por omissão, para o caso do browser não suportar geolocalização
// estas coordenadas apontam para a rotunda central da FCT-UNL
var default_coords = {
    latitude: 38.66099459829549,
    longitude: -9.204398794099689
};

$(document).ready(function () {
    // apenas permite numeros no campo do numero de telefone
    $(".numeric").numeric();

    var href = document.location.pathname;
    var register_page = href.indexOf("register") > -1;
    var new_account_page = href.indexOf("account/new") > -1;

    console.log(href);
    console.log(new_account_page);

    // 2 paginas de registo: /account/new ou /register
    if (register_page || new_account_page) {
        console.log("PAGINA DE REGISTO DO UTILIZADOR!!!!");

        if (navigator.geolocation) {
            // obtem as coordenadas do utilizador, e coloca-as escondidas no form
            navigator.geolocation.getCurrentPosition(geoSuccess, geoError);
        }
        else {
            populateUserCoords(default_coords);
            noty({
                text: 'Geolocalização não suportada por este browser!\n' +
                'A usar a localização por omissão: campus da FCT-UNL.',
                timeout: 3500, type: 'error', layout: 'bottomCenter'
            });
        }
    }
});

// função executada quando a posição atual é obtida com sucesso
function geoSuccess(position) {
    populateUserCoords(position.coords);

    noty({
        text: 'Localização obtida com sucesso!',
        timeout: 3500, type: 'success', layout: 'bottomCenter'
    });
}

function populateUserCoords(coords) {
    var text_coords = "POINT(" + coords.longitude + " " + coords.latitude + ")";
    console.log(text_coords);
    $('#user_latlon').val(text_coords);
}

// função executada quando ocorreu algum erro a obter a posição atual
// uma vez que nao conseguimos obter a localização, usa-se uma por omissão, neste caso o campus da FCT
function geoError() {
    populateUserCoords(default_coords);
    noty({
        text: 'Geolocalização desativada por ordem do utilizador.\n' +
        'A usar a localização por omissão: campus da FCT-UNL.',
        timeout: 3500, type: 'error', layout: 'bottomCenter'
    });
}