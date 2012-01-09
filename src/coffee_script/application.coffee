$ ->
  SB.App =
    init: ->
      @addCategories()
    addCategories: ->
      console.log(SB.Data)

  SB.App.init()
