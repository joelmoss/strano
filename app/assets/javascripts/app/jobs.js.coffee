$ ->
  
  if $('#job-results').size() > 0
  
    div = $ '#job-results'
    project_id = div.data 'project_id'
    job_id = div.data 'job_id'
  
    get_job_status = ->
      $.getJSON "/projects/#{project_id}/jobs/#{job_id}", (data) ->
        if data.results == null
          setTimeout get_job_status, 3000
        else
          div.text data.results
    
    setTimeout get_job_status, 3000
