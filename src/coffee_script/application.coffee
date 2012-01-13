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

      @nextQuestion bank, 0

    nextQuestion: (bank, index) ->
      # TODO: get rid of indexes and use named properties. keeping it this
      #       way for now b/c i'm manually entering data for testing
      context =
        question: bank[index][0]
        answer:   bank[index][1]
      $contentEl = $('#quiz #content')
      $contentEl.empty()
      html = SB.Templates.question(context)
      item = $(html).appendTo($contentEl)
      item.collapsible()
      $('#quiz #question-count').text(bank.length+' remaining')

      # TODO: refactor these into non-inline methods
      #       nextQuestion() is getting too long and varied

      # TODO: sloppy. don't need to continuosly bind/unbind things like this
      $('#quiz #shuffle-btn, #quiz #got-it-btn, #quiz #next-question-btn').unbind('click')

      $('#quiz #shuffle-btn').click (e) =>
        bank.shuffle()
        @nextQuestion(bank, 0)

      $('#quiz #got-it-btn').click (e) =>
        bank.remove(index)
        if bank.length is 0 then @quizComplete() else @nextQuestion bank, index

      $('#quiz #next-question-btn').click (e) =>
        index++
        index = 0 if index is bank.length
        @nextQuestion bank, index

    quizComplete: ->
      alert 'Nice job!'
      $.mobile.changePage($('#main'))

  SB.Templates =
    categories: Handlebars.compile $('#category-list-template').html()
    question:   Handlebars.compile $('#question-template').html()

  # kick this shit off
  SB.App.init()

# sort method ripped from coffeescriptcookbook.com
Array::shuffle = -> @sort -> 0.5 - Math.random()

# array remove stolen from jresig's blog and converted to coffeescript
Array::remove = (from, to) ->
  rest = @.slice((to or from) + 1 or @.length)
  @.length = if from < 0 then @.length + from else from
  @.push.apply @, rest

return
