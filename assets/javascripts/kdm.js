$(document).ready(function () {
    $.each($('#navbar').find('li'), function() {
        $(this).toggleClass('active',
            $(this).find('a').attr('href') == window.location.pathname);
    });

    jQuery("#gallery").unitegallery({
      tile_enable_icons:false,
      tiles_type: "justified",
    });
});
