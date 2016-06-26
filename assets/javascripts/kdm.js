$(document).ready(function () {
    $.each($('#navbar').find('li'), function() {
        $(this).toggleClass('active',
            $(this).find('a').attr('href') == window.location.pathname);
    });

    $('.facebook-photos').each(function() {
      $(this).magnificPopup({
        delegate: 'a',
        type: 'image',
        gallery: {
          enabled: true
        }
      });
    });
});
