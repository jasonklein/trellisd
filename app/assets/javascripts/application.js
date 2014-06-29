// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

var TrellisdApp = TrellisdApp || {};

TrellisdApp.mobileMenuSlider = function() {
  var menu = $('#navigation-menu');
  var menuToggle = $('#js-mobile-menu');

  $(menuToggle).on('click', function(e) {
    e.preventDefault();
    menu.slideToggle(function(){
      if(menu.is(':hidden')) {
        menu.removeAttr('style');
      }
    });
  });

  // underline under the active nav item
  $('.nav .nav-link').click(function() {
    $('.nav .nav-link').each(function() {
      $(this).removeClass('active-nav-item');
    });
    $(this).addClass('active-nav-item');
    $('.nav .more').removeClass('active-nav-item');
  });
};

TrellisdApp.expirationDatepicker = function() {
  $('#post_expiration').datepicker({
    numberOfMonths: 1,
    showButtonPanel: true,
    firstDay: 1,
    dateFormat: "yy-mm-dd"
  });
};

TrellisdApp.usersSearch = function() {
  $('#q_first_name_or_last_name_or_full_name_cont').on('keyup', function() {
    $('#user_search').submit();
  });
};

TrellisdApp.setup = function() {
  TrellisdApp.mobileMenuSlider();
  TrellisdApp.expirationDatepicker();
  TrellisdApp.usersSearch();
}

$(TrellisdApp.setup);
