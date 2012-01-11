$ ->
  SB.App =
    init: ->
      @addCategories()
    addCategories: ->
      # is there a better way to get the iteration index here?
      index = -1
      context = for category of SB.Data
        index++
        obj =
          index: index
          name: category

      $container = $('#main #categories')
      $(SB.Templates.categories(context)).appendTo($container)
      $('#main').trigger('create')

  SB.Templates =
    categories:
      Handlebars.compile( $('#category-list-template').html() )

  SB.App.init()
