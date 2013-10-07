$(document).ready(function() {
	
	searchResults = [];

	$("#btn_lucky").on("click", function(event){
		$.ajax({
			url: './lucky',
			type: "POST",
			dataType: 'text/plain',
			data: $("#txt_input").val(),
			success: luckySuccess,
			error: clearInput
		});
	});

	$("#btn_search").on("click", function(event){
		$.ajax({
			url: './search',
			type: "POST",
			contentType: 'text/plain',
			dataType: 'json',
			data: $("#txt_input").val(),
		}).done(
			searchSuccess
		).fail(
			clearInput
		);
	});

	$("#btn_back").on("click", function(event){
		$('.carousel').carousel('prev');
	});

	function luckySuccess(data) {

	};

	function populateSearchResults() {
		searchResultsHtml = "";
		var cap = 4;
		if (cap > searchResults.length) {
			cap = searchResults.length;
		}
		for(var i=0; i<cap; i++) {
			searchResultsHtml += 
				"<div class='panel panel-default'>"
					+ "<div class='panel-body'>"
			    		+ "<span class='song-name'>" + searchResults[i].songName + "</span>" 
			    		+ "<br />"
			    		+ "<span class='artist-name'>" + searchResults[i].artistName + "</span>"
			    		+ "<span class='glyphicon glyphicon-play'></span>"
			    	+ "</div>"
			   + "</div>";
		}
			
		$("#search-results").html(searchResultsHtml);
	};

	function searchSuccess(data) {
		searchResults = data;
		if(searchResults.length > 0) {
			populateSearchResults();
			$('.carousel').carousel('next');
		}
		clearInput();
	};

	function clearInput() {
		$("#txt_input").val("");
	};

	$('.carousel').carousel({
  		interval: false
	});
});
