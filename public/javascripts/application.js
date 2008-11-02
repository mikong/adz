// Common JavaScript code across your application goes here.

$(function(){
	// find error with Login required.
	if ( $("#msg_error:contains('Login required)").length )
	  $("input[name='login']").focus();
});
