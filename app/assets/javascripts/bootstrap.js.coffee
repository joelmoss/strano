$ ->
  $("a[rel=twipsy]").twipsy live: true
  
$ ->
  $("a[rel=popover]").popover offset: 10
  
$ ->
  domModal = $(".modal").modal(
    backdrop: true
    closeOnEscape: true
  )
  $(".open-modal").click ->
    domModal.toggle() 
     
$ ->
	$(".btn").button "complete"
