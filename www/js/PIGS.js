$(document).ready(function() {
	
	var searchResults = [];
	var requestedArtist = "";
	var requestedSong = "";

	var opts = {
		lines: 10, // The number of lines to draw
		length: 20, // The length of each line
		width: 5, // The line thickness
		radius: 15, // The radius of the inner circle
		corners: 1, // Corner roundness (0..1)
		rotate: 0, // The rotation offset
		direction: 1, // 1: clockwise, -1: counterclockwise
		color: '#000', // #rgb or #rrggbb or array of colors
		speed: 1, // Rounds per second
		trail: 60, // Afterglow percentage
		shadow: false, // Whether to render a shadow
	 	hwaccel: false, // Whether to use hardware acceleration
		className: 'spinner', // The CSS class to assign to the spinner
		zIndex: 2e9, // The z-index (defaults to 2000000000)
		top: 0, // Top position relative to parent in px
		left: 'auto' // Left position relative to parent in px
	};
	var spinner = new Spinner(opts);

	$("#btn-lucky").on("click", function(event){
		spinner.spin(document.getElementById('container'));
		$.ajax({
			url: './lucky',
			type: 'POST',
			contentType: 'text/plain',
			dataType: 'json',
			data: $("#txt-input").val()
		}).done(
			luckySuccess
		).fail(
			luckyFailure
		);
	});

	$("#btn-search").on("click", function(event){
		spinner.spin(document.getElementById('container'));
		$.ajax({
			url: './search',
			type: 'POST',
			contentType: 'text/plain',
			dataType: 'json',
			data: $("#txt-input").val()
		}).done(
			searchSuccess
		).fail(
			searchFailure
		);
	});

	$(".glyphicon-pause").on("click", function(event){
		spinner.spin(document.getElementById('container'));
		$.ajax({
			url: './control',
			type: 'POST',
			contentType: 'text/plain',
			dataType: 'json',
			data: 'pause_unpause'
		}).done(
			controlSuccess
		).fail(
			controlFailure
		);
	});

	$(".glyphicon-remove").on("click", function(event){
		spinner.spin(document.getElementById('container'));
		$.ajax({
			url: './control',
			type: 'POST',
			contentType: 'text/plain',
			dataType: 'json',
			data: 'stop'
		}).done(
			controlSuccess
		).fail(
			controlFailure
		);
	});

    $(".glyphicon-volume-down").on("click", function(event){
		spinner.spin(document.getElementById('container'));
		$.ajax({
			url: './control',
			type: 'POST',
			contentType: 'text/plain',
			dataType: 'json',
			data: 'volume_down'
		}).done(
			controlSuccess
		).fail(
			controlFailure
		);
	});

    $(".glyphicon-volume-up").on("click", function(event){
		spinner.spin(document.getElementById('container'));
		$.ajax({
			url: './control',
			type: 'POST',
			contentType: 'text/plain',
			dataType: 'json',
			data: 'volume_up'
		}).done(
			controlSuccess
		).fail(
			controlFailure
		);
	});

	$("#btn-back").on("click", function(event){
		$('.carousel').carousel('prev');
	});

	function luckySuccess(data) {
		spinner.stop();
		clearInput();
		if(data != null) {
			showSuccessBar("Playing: " + data.artistName + " - " + data.songName);
		}
		else {
			showErrorBar("There was an error. Try again.");
		}
	};

	function luckyFailure() {
		spinner.stop();
		clearInput();
		showErrorBar("There was an error. Try again.");
	};

	function controlSuccess(data) {
		spinner.stop();
		clearInput();
		if(data.success) {
			showSuccessBar("Success!");
		}
		else {
			showErrorBar("There was an error. Try again.")
		}
	};

	function controlFailure() {
		spinner.stop();
		clearInput();
		showErrorBar("There was an error. Try again.")
	};

	function playSuccess(data) {
		spinner.stop();
		clearInput();
		$('.carousel').carousel('prev');
		if(data.success) {
			showSuccessBar("Success!");
		}
		else {
			showErrorBar("There was an error. Try again.")
		}
	};

	function playFailure() {
		spinner.stop();
		clearInput();
		showErrorBar("There was an error. Try again.")
	};

	function searchSuccess(data) {
		spinner.stop();
		searchResults = data;
		if(searchResults.length > 0) {
			populateSearchResults();
			$('.carousel').carousel('next');
		}
		clearInput();
	};

	function searchFailure() {
		spinner.stop();
		clearInput();
		showErrorBar("There was an error. Try again.")
	};

	function populateSearchResults() {
		var searchResultsHtml = "";
		var cap = 8;
		if (cap > searchResults.length) {
			cap = searchResults.length;
		}
		for(var i=0; i<cap; i++) {
			searchResultsHtml += 
				"<div class='panel panel-default result-panel' id='" + searchResults[i].songID + "'>"
					+ "<div class='panel-body'>"
						+ "<div class='result-info'>"
			    			+ "<span class='song-name'>" + searchResults[i].songName + "</span>" 
			    			+ "<br />"
			    			+ "<span class='artist-name'>" + searchResults[i].artistName + "</span>"
			    		+ "</div>"
			    		+ "<div class='result-icon'>"
			    			+ "<br />"
			    			+ "<span class='glyphicon glyphicon-play'></span>"
			    		+ "</div>"
			    	+ "</div>"
			   + "</div>";
		}
			
		$("#search-results").html(searchResultsHtml);
		$(".result-panel").on("click", function(event){
			spinner.spin(document.getElementById('container'));
			$.ajax({
				url: './play',
				type: "POST",
				contentType: 'text/plain',
				dataType: 'json',
				data: $(this).attr('id')
			}).done(
				playSuccess
			).fail(
				playFailure
			);

		});
	};

	function clearInput() {
		$("#txt-input").val("");
	};

	function showErrorBar(message) {
		showNotificationBar(message, 3000, "#cc0000", "#ffffff", 40);
	};

	function showSuccessBar(message) {
		showNotificationBar(message, 3000, "#4ca64c", "#ffffff", 40);
	};

	function showNotificationBar(message, duration, bgColor, txtColor, height) {
 
	    if ($('#notification-bar').size() == 0) {
	        var HTMLmessage = "<div class='notification-message' style='text-align:center; line-height: " + height + "px;'> " + message + " </div>";
	        $('body').prepend("<div id='notification-bar' style='display:none; width:100%; height:" + height + "px; background-color: " + bgColor + "; position: fixed; z-index: 100; color: " + txtColor + ";border-bottom: 1px solid " + txtColor + ";'>" + HTMLmessage + "</div>");
	    }
	    $('#notification-bar').slideDown(function() {
	        setTimeout(function() {
	            $('#notification-bar').slideUp(function() {
	            	$('#notification-bar').remove();
	            });
	        }, duration);
	    });
	};

	$('.carousel').carousel({
  		interval: false
	});
});
