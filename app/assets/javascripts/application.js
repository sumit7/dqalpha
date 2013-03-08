// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery-migrate
//= require jquery.hovercard
//= require jquery_ujs
//= require jquery.ui.all
//= require jquery.layout
//= require jquery.layout.pseudoClose
//= require bjqs
//= require ckeditor/init
//= require ckeditor/config
//= require jquery.jscrollpane
//= require jquery.mousewheel
//= require_tree .
$(function() {	

//new quest text fields
    
       $("textarea#quest_description").blur(function() {
        if ($(this).val() == "") {
            $(this).val("Provide a description");
            
        }
    }).focus(function() {
        if ($(this).val() == "Provide a description") {
            $(this).val("");
              
        }
    });
      $("input#quest_title").blur(function() {
        if ($(this).val() == "") {
            $(this).val("A name for the Quest");
              
        }
    }).focus(function() {
        if ($(this).val() == "A name for the Quest") {
            $(this).val("");
              
        }
    });

//new q text field

 

	//for wiki selection
    	 $(document.body).bind('mouseup', function(e){
        var selection;
        
        if (window.getSelection) {
          selection = window.getSelection();
          
        } else if (document.selection) {
          selection = document.selection.createRange();
        }
         var mousePos;
         mousePos = {left: e.pageX , top: e.pageY};   
        
        if(selection.toString() != ''&& !$("#onselection_list").is(":visible")) {
            
            $('#onselection_list').css("position","fixed");
            $('#onselection_list').css("top",mousePos.top);
            $('#onselection_list').css("left",mousePos.left);
            $('#onselection_list p').html(selection.toString());
            $('#onselection_list').show();
            $("#onselection_list button").show();   
    		
        
        } 
        else if(selection.toString()!=""){
            
        }
        else {
            	 $('#onselection_list p').html("");
        
            $('#onselection_list').hide();
        }
    });
     	
 //git browse repo
   $("a.grey").live("click", function() {
    $.getScript(this.href);
    window.history.pushState(null, document.title, this.href);
     return false;
  });
  $(".dashboard_right a").live("click", function() {
  
    $.getScript(this.href);
    window.history.pushState(null, document.title, this.href);
     return false;
  });
  
  $(".content_middle a").live("click", function() {
    $.getScript(this.href);
    window.history.pushState(null, document.title, this.href);
     return false;
  });
   $(".quests_show a").live("click", function() {
    $.getScript(this.href);
    window.history.pushState(null, document.title, this.href);
     return false;
  });
  $("#leftcontent a").live("click", function() {
    $.getScript(this.href);
    window.history.pushState(null, document.title, this.href);
     return false;
  });
  $("#q text.grey a").live("click", function() {
    $.getScript(this.href);
    window.history.pushState(null, document.title, this.href);
     return false;
  });
  $("#wikiinfo a").live("click", function() {
    $.getScript(this.href);
     return false;
 });
  $("a #mashup_links").live("click", function() {
    $.getScript(this.href);
     return false;
 });
 
  
  
   $(window).bind("popstate", function() {
      $.getScript(location.href);
    });

  if ($("#com").length > 0) {
    setTimeout(updateComments, 100000);
  }
	
	});
function updateComments () {
  var q_id = $("#q").attr("data-id");
  if ($(".post").length > 0) {
    var after = $(".post:last-child").attr("data-time");
  } else {
    var after = "0";
  }
  $.getScript("/qs/"+ q_id +"/qmails.js?q_id=" + q_id + "&after=" + after)
  setTimeout(updateComments, 100000);
}

//send for search to wiki
    	function search_wiki () {
    		 var selection;
        
        if (window.getSelection) {
          selection = window.getSelection();
          
        } else if (document.selection) {
          selection = document.selection.createRange();
        }
        
    		   $.getScript("/wik?ad="+selection.toString());
    		  	 $('#onselection_list button').hide(400,function(){   $( "#onselection_list" ).animate({
  				left: 50, opacity: 1,
    	
          	top:  $("#rightcontent").position().top,
    		   	left:$("#rightcontent").position().left
    		    
			}, 800 );});
        
    		 
			$("#link_1").click();
    	     
    	}
