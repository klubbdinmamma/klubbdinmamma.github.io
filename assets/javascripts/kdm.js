$(document).ready(function() {
    $.each($('#navbar').find('li'), function() {
        $(this).toggleClass('active',
            $(this).find('a').attr('href') == window.location.pathname);
    });

    $(".gallery").each(function() {
        $(this).unitegallery({
            tile_enable_icons:false,
            tiles_type: "justified",
        });
    });

    ScrollTrigger.init();
});

// http://stackoverflow.com/questions/14425300/scale-image-properly-but-fit-inside-div
$('.news-photo').on('load', function() {
    console.log("on news-photo load: "+$(this).attr('src'));
    var css;
    var ratio=$(this).width() / $(this).height();
    var pratio=$(this).parent().width() / $(this).parent().height();
    if (ratio<pratio) css={width:'auto', height:'100%'};
    else css={width:'100%', height:'auto'};
    $(this).css(css);
});
