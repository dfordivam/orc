// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//
jQuery(document).ready(function(){
      
	  $("#event_start_date_time,#event_end_date_time").datepicker({
        dateFormat: 'dd MM yy'
      });

    jQuery(function($){
	  // when the #search field changes
      $("#room_building_id").change(function(){
        $.post('roomsearch', $("#building_id") ,  function(data) {
          alert("data :" + data);
          $("#rooms_result").html(data);
          });
        });
      });
    });
