// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function formatLinkForPaginationURL() {
  $("div.pagination").find("a").each(function() {
        var linkElement = $( this );
        var paginationURL = linkElement.attr("href");
        linkElement.attr({
             "url": paginationURL,
             "href": "#"
        });
		
        linkElement.click(function() {
              $("#pagination_display_section").load( $(this).attr('url') );
              return false;
        });			
   });
}

$(document).ready(function() {
  $('input.ui-date-text').live('change', function(){
    var sels = [];
    sels[0]=$("select[id$='_1i']");
    sels[1]=$("select[id$='_2i']");
    sels[2]=$("select[id$='_3i']");

    var d =$.datepicker.parseDate($.datepicker._defaults.dateFormat, $(this).val());
    if (d != null){
      $(sels[0]).val(d.getFullYear());
      $(sels[1]).val(d.getMonth()+1);
      $(sels[2]).val(d.getDate());
    }else{
      $(sels[0]).val('');
      $(sels[1]).val('');
      $(sels[2]).val('');
    };
  });
  $('.date, .datetime').each(function(i,el){
    var input=document.createElement('input');
    $(input).attr({'type': 'text','class': 'ui-date-text'});
    $(el).find('select:first').before(input);
    
	$(el).find('select:lt(3)').hide();

    var values=[];
    values[0]=$("select[id$='_1i']").val();
    values[1]=$("select[id$='_2i']").val();
    values[2]=$("select[id$='_3i']").val();
    if(values[0] != '' &amp; values[1] != '' &amp; values[2] != '') {
      d = new Date(values[0], parseInt(values[1] - 1), values[2]);
      $(input).val($.datepicker.formatDate($.datepicker._defaults.dateFormat,d));
    };
    $(input).datepicker();
  });
  
  $(".hasDatepicker").css("background-color","#ff9");
});