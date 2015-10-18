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
            if ($(this).is(':checked')) {
                console.log($(this));
            }
        });


    $(document).ready(function() {
        $('select').material_select();
    });
});