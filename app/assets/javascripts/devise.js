// documento carregado na pagina de login/registo

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
            navigator.geolocation.getCurrentPosition(geoSucess, geoError);
        } else {
            noty({
                text: 'Geolocalização não suportada por este browser!',
                timeout: 3500, type: 'error', layout: 'bottomCenter'
            });
        }
    }
});

// função executada quando a posição atual é obtida com sucesso
function geoSucess(position) {
    var text_coords = "POINT(" + position.coords.longitude + " " + position.coords.latitude + ")";
    console.log(text_coords);
    $('#user_latlon').val(text_coords);

    noty({
        text: 'Localização obtida com sucesso!',
        timeout: 3500, type: 'success', layout: 'bottomCenter'
    });
}

// função executada quando ocorreu algum erro a obter a posição atual
function geoError() {
    noty({
        text: 'Geolocalização desativada por ordem do utilizador.',
        timeout: 3500, type: 'error', layout: 'bottomCenter'
    });
}