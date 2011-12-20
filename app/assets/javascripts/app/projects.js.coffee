$ ->
  
  $('.show-task-description').click ->
    $(this).parent().parent().siblings().toggle()
    $(this).text if $(this).text().indexOf('hide') < 0 then 'hide full description >' else 'show full description >'