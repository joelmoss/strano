# History Initialization
# ---------------------------------------------------------------------------

`(function(window,undefined){

  var History = window.History;
  if (!History.enabled) return false;

  History.Adapter.bind(window, 'statechange', function() {
    var State = History.getState();
    if (State.data.tab) $("li a[href=#"+State.data.tab+"]").trigger('click');
  });

})(window);`


$ ->
  
  # Miscellaneous
  # ---------------------------------------------------------------------------
  
  $("a[rel=twipsy]").tooltip live: true  
  $("a[rel=popover]").popover offset: 10
  $(".alert").alert()


  # Tabs Initialization
  # ---------------------------------------------------------------------------

  tabs = $('[data-toggle=tab], [data-toggle=pill]')


  # Handle the right well for tabs if one exists.
  if $('#tabwell').size() > 0
    
    tabs.on 'shown', (e) ->
      activated = $(e.target) # activated tab
      previous = $(e.relatedTarget) # previous tab

      if activated.attr('href').indexOf('#') is 0
        name = activated.attr('href').replace '#', ''
        
        if $("#tabwell-#{name}").size() > 0
          $("#tabwell-#{name}").show()
        
      if previous.attr('href').indexOf('#') is 0
        name = previous.attr('href').replace '#', ''

        if $("#tabwell-#{name}").size() > 0
          $("#tabwell-#{name}").hide()


  # Set the location hash on tab click
  tabs.on 'show', ->
    tab = $(this).attr('href').replace /#/, ''
    params = $.getUrlVars()
    params['tab'] = tab
    
    History.pushState {tab: tab}, null, "?" + $.param(params)

  if History.getState().data.tab != undefined
    # Set selected tab as active
    tabs.parents('ul').find("li a[href=##{History.getState().data.tab}]").trigger 'click'

  else if (tab = $.getUrlVar('tab')) != undefined
    tabs.parents('ul').find("li a[href=##{tab}]").trigger 'click'
  
  else
  
    # Set first tab as active if none are active
    active_tab = tabs.find('li.active a')
    if active_tab.size() < 1
      tabs.find('li:first a').trigger 'click'
    else
      active_tab.trigger 'click'

  # Select the first tab that contains an asterisk (has form errors)
  tabs.parents('ul').find('li a:contains(*):first').trigger 'click'
