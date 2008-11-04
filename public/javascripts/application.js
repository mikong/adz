// Common JavaScript code across your application goes here.

$(function(){
	// find error with Login required.
	if ( $("#msg_error:contains('Login required)").length )
	  $("input[name='login']").focus();
});

function prepare_custom_ad() {
	var checkbox = $("#add_custom_1");
  var paragraph = $("p:has(#ad_text)");
  if (checkbox.attr("checked") == "")
    paragraph.hide();
  checkbox.change(function() {
    if ( $(this).attr("checked") == "") {
      if ( paragraph.is(':visible') )
        paragraph.slideUp();
    } else {
      if ( paragraph.is(':hidden') )
        paragraph.slideDown();
    }
  });
}
