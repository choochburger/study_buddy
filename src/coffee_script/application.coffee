$ ->
  SB.App =
    init: ->
      @addCategories()
    addCategories: ->
      context = for category, i of SB.Data
        obj =
          # need to get the actual index here
          index: 0
          name: category

      $ul = $('#main ul')
      $(SB.Templates.categories(context)).appendTo($ul)
      $ul.listview('refresh')

  SB.Templates =
    categories:
      Handlebars.compile( $('#category-list-template').html() )

  SB.App.init()
