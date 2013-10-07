$(document).ready(function() {
	
	$("#btn_lucky").on("click", function(event){
		$.ajax({
			url: './lucky',
			type: "POST",
			dataType: 'text/plain',
			data: $("#txt_input").val(),
			success: clearInput,
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

	function searchSuccess(data) {
		clearInput();
		$('#search-results').html(JSON.stringify(data));
		$('.carousel').carousel('next');
	};

	function clearInput() {
		$("#txt_input").val("");
	};

	$('.carousel').carousel({
  		interval: false
	});
});
