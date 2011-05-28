// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//
jQuery(document).ready(function(){
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
