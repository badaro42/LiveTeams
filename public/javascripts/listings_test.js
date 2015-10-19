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


    $(document).ready(function () {
        $('select').material_select();
    });
});