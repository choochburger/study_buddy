$ ->

  addCategories = ->
    $.ajax {
      url: 'data.json'
      dataType: 'json'
      success: (data) ->
        for category, name of data
          console.log name
    }

  addCategories()
