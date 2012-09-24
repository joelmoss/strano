$ ->
  $("#job_stage").change ->
    self = $(this)
    val = self.val()
    url = '?stage=' + val
    xhr = $.ajax({
      url: url,
      dataType: 'script'
    })

  $("#slider").slider
    value: 3
    min: 1
    max: 3
    slide: (event, ui) ->
      num = ui.value+1
      verbosity = while num -= 1 then 'v'
      $("#job_verbosity").val verbosity.join('')


  if $('#job-results').size() > 0

    div = $ '#job-results'
    project_id = div.data 'project_id'
    job_id = div.data 'job_id'

    get_job_status = ->
      $.getJSON "/projects/#{project_id}/jobs/#{job_id}", (data) ->
        if data.completed_at == null
          setTimeout get_job_status, 3000
        else
          title = div.siblings('h3')
          title.find('img').remove()
          text = title.text().replace /Running/, 'Task'
          text = text.replace /\.\.\./, 'completed'
          title.text text

          $('.alert').remove()

          if data.success
            $('.tabbable .nav .pull-right').html '<span class="label label-success">SUCCESS</span>'
          else
            $('.tabbable .nav .pull-right').html '<span class="label label-important">FAILED</span>'

        div.removeClass('hide').html data.results if data.results != null

    setTimeout get_job_status, 3000
