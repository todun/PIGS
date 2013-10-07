$(document).ready(function() {
	
	$("#btn_lucky").on("click", function(event){
		$.ajax({
			url: './lucky',
			type: "POST",
			dataType: 'text/plain',
			data: $("#txt_input").val(),
			success: clearInput(),
			error: clearInput()
		});
	});

	function clearInput() {
		$("#txt_input").val("");
	};
});