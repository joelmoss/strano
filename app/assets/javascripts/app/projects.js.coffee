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
  getProject = ->
    html = $('#repo-update').html()
    
    $.getJSON location, (data) ->
      
      if $('#clone-msg').size() > 0
        if data.cloned_at == null
          time_diff = new Date() - new Date(data.created_at)
        
          # older than 15 minutes and cloning has still not completed.
          if time_diff > (1000 * 900)
            msg = "Cloning seems to have failed as it has been running for over 15 minutes now."
            $('#clone-msg').addClass('error').removeClass('info').text msg
        else
          window.location.reload false
          
      else if $('#repo-update').size() > 0
        if data.pull_in_progress == true
          $('#repo-update').text 'updating...'
        else
          $('#repo-update').html html
          $('#repo-update abbr').text $.timeago(data.pulled_at)
          $('#repo-update abbr').attr 'title', $.timeago(data.pulled_at)
          
      setTimeout getProject, 5000
  
  setTimeout getProject, 5000