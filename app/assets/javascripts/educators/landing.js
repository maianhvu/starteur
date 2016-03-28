function removePreload() {
	document.body.className = "educators_sessions new";
	startAnimation();
};

function toggleStickyHeader() {
	if ($(window).scrollTop() >= 72) {
    $('#header-wrapper').addClass('sticky-header');
		$('#header-wrapper').css('height', '56px');
		$('#top-break').css('padding-top', '120px');
  } else {
    $('#header-wrapper').removeClass('sticky-header');
		$('#header-wrapper').css('height', '48px');
		$('#top-break').css('padding-top', '72px');
	}
};

document.addEventListener("touchmove", toggleStickyHeader, false);
document.addEventListener("touchend", toggleStickyHeader, false);
document.addEventListener("scroll", toggleStickyHeader, false);

function startAnimation() {
	if ($(window).width() > 951) {
		var preload = ["/images/hero-filmstrip.png"];
		var promises = [];
		for (var i = 0; i < preload.length; i++) {
			(function(url, promise) {
				var img = new Image();
				img.onload = function() {
				  promise.resolve();
				};
				img.src = url;
			})(preload[i], promises[i] = $.Deferred());
		}
		$.when.apply($, promises).done(function() {
			$('.hero-image .filmstrip').css('background-image', "url(/images/hero-filmstrip.png)");
			$('.hero-image .filmstrip').css('background-size','3000% 100%');
		});
	}
}

// TRACKING
$(document).ready(function() {
	$('#sign-up-button-top').on('click', function() {
	  ga('send', 'event', 'button', 'click', 'Sign up button (Top)');
	});
	$('#sign-up-button-bottom').on('click', function() {
	  ga('send', 'event', 'button', 'click', 'Sign up button (Bottom)');
	});
});
