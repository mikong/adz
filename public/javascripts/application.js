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

function sms_preview_sponsor() {
	var sponsor = $("span.sms-preview-sponsor");
  var sponsor_input = $("#ad_sponsor");
  var update_sponsor_func = function() {
    if ( $(sponsor_input).val() == "") {
      sponsor.text("<Sponsor>");
    } else {
      sponsor.text($(sponsor_input).val());
    }
  };
  
  update_sponsor_func();
  sponsor_input.change(update_sponsor_func);
}
