$ ->
  
  $('.show-task-description').click ->
    $(this).parent().parent().siblings().toggle()
    $(this).text if $(this).text().indexOf('hide') < 0 then 'hide full description >' else 'show full description >'
    
    false


  $('#toggle_other_tasks').click ->
    div = $ '#other_tasks'
    icon = $(this).find 'span'

    if div.is(':visible')
      $(this).find('small').text 'show'
      icon.addClass 'ui-icon-circle-triangle-s'
      icon.removeClass 'ui-icon-circle-triangle-n'
    else
      $(this).find('small').text 'hide'
      icon.addClass 'ui-icon-circle-triangle-n'
      icon.removeClass 'ui-icon-circle-triangle-s'
    
    div.toggle()
    
    
# Check that the current project has completed cloning
$.extend
  check_project_cloning: ->
    
    getProject = ->
      $.getJSON location, (data) ->
        if data.cloned_at == null
          time_diff = new Date() - new Date(data.created_at)
          
          # older than 15 minutes and cloning has still not completed.
          if time_diff > (1000 * 900)
            msg = "Cloning seems to have failed as it has been running for over 15 minutes now."
            $('#clone-msg').addClass('error').removeClass('info').text msg
          else
            setTimeout getProject, 5000
        else
          window.location.reload false
    
    setTimeout getProject, 5000