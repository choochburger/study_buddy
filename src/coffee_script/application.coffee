$ ->
  SB.App =
    init: ->
      @addCategories()

      # listen for page loads and act as router
      $(document).bind 'pagechange', @onPageChange

    onPageChange: (e, data) =>
      switch location.hash
        when '#quiz' then SB.App.startQuiz()

    addCategories: ->
      # add an index to each data item
      for index, category of SB.Data.categories
        category['index'] = index

      $container = $('#main #categories')
      html = SB.Templates.categories(SB.Data.categories)
      $(html).appendTo($container)
      $('#main').trigger('create')

    startQuiz: ->
      # assemble a bank of questions based on user selection
      bank = []
      selected = $('#main #categories input:checked')
      for inputEl in selected
        index = $(inputEl).attr('index')
        category = SB.Data.categories[index]
        for question in category.items
          bank.push question

      @nextQuestion bank[0], bank

    nextQuestion: (question, bank) ->
      # TODO: get rid of indexes and use named properties. keeping it this
      #       way for now b/c i'm manually entering data for testing
      context =
        question: question[0]
        answer: question[1]
      $contentEl = $('#quiz #content')
      $contentEl.empty()
      html = SB.Templates.question(context)
      item = $(html).appendTo($contentEl)
      item.collapsible()
      $('#quiz #question-count').text(bank.length+' remaining')

  SB.Templates =
    categories: Handlebars.compile $('#category-list-template').html()
    question:   Handlebars.compile $('#question-template').html()

  # kick this shit off
  SB.App.init()
