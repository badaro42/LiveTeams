// documento carregado na pagina de login/registo

// coordenadas por omissão, para o caso do browser não suportar geolocalização
// estas coordenadas apontam para a rotunda central da FCT-UNL
var default_coords = {
    latitude: 38.66099459829549,
    longitude: -9.204398794099689
};

var password_valid = false;
var full_name_valid = false;
var email_valid = false;
var phone_number_valid = false;
var avatar_valid = false;

$(document).ready(function () {
    // apenas permite numeros no campo do numero de telefone
    $(".numeric").numeric();

    var href = document.location.pathname;
    var register_page = href.indexOf("register") > -1;
    var new_account_page = href.indexOf("account/new") > -1;

    console.log(href);
    console.log(new_account_page);

    // 2 paginas de registo: /account/new ou /register
    // no caso de haver algum erro no registo, o utilizador é redirecionado para "/account"
    if (register_page || new_account_page || href === "/account") {
        console.log("PAGINA DE REGISTO DO UTILIZADOR!!!!");

        var pass_elem = "#user_password";
        var pass_conf_elem = "#user_password_confirmation";

        // verifica se as passwords coincidem e se o comprimento é maior ou igual a 8
        $(".password").on("keyup", function (e) {
            var password = $(pass_elem).val();
            var pass_confirmation = $(pass_conf_elem).val();

            password_valid = ((password === pass_confirmation) && (password.length >= 8));
            checkIfFormIsValid();
        });

        // verifica se o avatar é valido
        $(".avatar").on("change", function (e) {
            avatar_valid = ($(e.target).val().length > 0);
            checkIfFormIsValid();
        });

        //verifica se o email é valido
        $(".email").on("keyup", function (e) {
            email_valid = validateEmail($(e.target).val());
            checkIfFormIsValid();
        });

        //verifica se o numero de telefone introduzido é valido
        $(".phone_number").on("keyup", function(e) {
            phone_number_valid = ($(e.target).val().length == 9);
            checkIfFormIsValid();
        });

        //verifica se pelo menos existe um caracter em ambos os campos
        $(".username").on("keyup", function (e) {
            var first_name_val = $("#user_first_name").val();
            var last_name_val = $("#user_last_name").val();

            full_name_valid = (first_name_val.length > 0 && last_name_val.length > 0);
            checkIfFormIsValid();
        });


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

//verifica se todas as condições são validas
//se sim, ativa o botao do formulario e permite criar o utilizador
function checkIfFormIsValid() {
    if (password_valid && full_name_valid && email_valid && phone_number_valid && avatar_valid)
        $("#submit_register_form").attr("disabled", false);
    else
        $("#submit_register_form").attr("disabled", true);
}

//expressão regex que permite validar o email introduzido
//http://stackoverflow.com/a/46181/3415004
function validateEmail(email) {
    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
}