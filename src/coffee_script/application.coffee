window.SB = window.SB || {}

$ ->

  SB.Data = {}

  SB.Credentials = {}

  SB.App =
    init: ->
      @checkHashForAuth()

      SB.Data.categories = @initData()
      @startApp(SB.Data.categories)

      # listen for page loads and act as router
      $(document).bind 'pagechange', @onPageChange

      # page isn't always visible for some reason...
      $('body').css('visibility', 'visible')

    checkHashForAuth: ->
      return if location.hash.indexOf('access_token') is -1

      params = location.hash.split('&')
      params[0] = params[0].split('#')[1]
      SB.Credentials = {}

      for param in params
        param = param.split('=')
        SB.Credentials[param[0]] = param[1]

      $.mobile.changePage($('#spreadsheet-list'))

    initData: ->
      return JSON.parse(localStorage.categories) if localStorage.categories
      SB.Data.categories = []

    startApp: ->
      if (SB.Data.categories.length)
        @addCategories()
      else
        if SB.Credentials.access_token
          @loadSpreadsheets()
        else
          @noDataFound()

    onPageChange: (e, data) =>
      id = data.toPage.attr('id')
      switch id
        when 'quiz' then SB.App.startQuiz()
        when 'spreadsheet-list' then SB.App.loadSpreadsheets()

    noDataFound: ->
      $.mobile.changePage('#no-data', {
        transition: 'slidedown'
        role:       'dialog'
      })
      @removeDialogX()

    removeDialogX: ->
      $('.ui-dialog .ui-btn-icon-notext .ui-icon').closest('a')
                                                  .remove()

    addCategories: ->
      # add an index to each data item
      for index, category of SB.Data.categories
        category['index'] = index

      $container = $('#main #categories')
      $container.empty()
      html = SB.Templates.categories(SB.Data.categories)
      $(html).appendTo($container)
      $('#main').trigger('create')

      $('#main #start-quiz-btn').click =>
        selected = $('#main #categories input:checked')

        if not selected.length
          return @showError 'Please select some categories from the menu.'

        $.mobile.changePage $('#quiz')


    showError: (msg) ->
      $.mobile.changePage('#error', {
        transition: 'slidedown'
        role:       'dialog'
      })

      $('#error #error-msg').text(msg)

    startQuiz: ->
      # assemble a bank of questions based on user selection
      bank = []
      selected = $('#main #categories input:checked')

      for inputEl in selected
        index = $(inputEl).attr('index')
        category = SB.Data.categories[index]
        for question in category.items
          bank.push question

      $('#quiz #flip-data').unbind('click')
                           .bind('click', {'bank': bank}, @flipData)

      @nextQuestion bank, 0

    flipData: (e) =>
      bank = e.data.bank
      for entry in bank
        question = entry.question
        answer   = entry.answer
        entry.question = answer
        entry.answer   = question

      SB.App.nextQuestion bank, 0

    nextQuestion: (bank, index) ->
      $contentEl = $('#quiz #content')
      $contentEl.empty()

      context = bank[index]
      html = SB.Templates.question(context)
      $question = $(html).appendTo($contentEl)

      $('#quiz #question-count').text(bank.length+' remaining')

      $btnsContainer   = $('#quiz #buttons')
      $shuffleBtn      = $('#quiz #shuffle-btn')
      $gotItBtn        = $('#quiz #got-it-btn')
      $nextQuestionBtn = $('#quiz #next-question-btn')
      btns             = [$shuffleBtn, $gotItBtn, $nextQuestionBtn]

      $(btns).unbind('click')
             .button()
      $btnsContainer.controlgroup()
      $question.collapsible()

      $shuffleBtn.click (e) =>
        bank.shuffle()
        @nextQuestion(bank, 0)

      $gotItBtn.click (e) =>
        bank.remove(index)
        nextIndex = bank.length - 1
        if nextIndex < 0 then @quizComplete() else @nextQuestion bank, nextIndex

      $nextQuestionBtn.click (e) =>
        index++
        index = 0 if index is bank.length
        @nextQuestion bank, index

      $('#quiz #back').click =>
        $.mobile.changePage($('#main'))

      return

    quizComplete: ->
      $('#quiz #content').empty()
      $.mobile.changePage('#quiz-complete', {
        transition: 'flip'
        role:       'dialog'
      })
      @removeDialogX()

    loadSpreadsheets: ->
      if not SB.Credentials.access_token
        @authenticateUser()
        return

      baseUrl = 'https://spreadsheets.google.com/feeds/spreadsheets/private/full'
      url = @getFullUrl baseUrl

      $.mobile.showPageLoadingMsg()
      $.ajax {
        url: url
        dataType: 'jsonp'
        success: (data) =>
          $.mobile.hidePageLoadingMsg()
          @renderSpreadsheetList data.feed.entry
        error: ->
          $.mobile.hidePageLoadingMsg()
          alert 'Problem fetching data.'
      }

    getFullUrl: (baseUrl) ->
      accessToken = "access_token=#{SB.Credentials.access_token}"
      alt         = 'alt=json-in-script'

      "#{baseUrl}?#{accessToken}&#{alt}"

    renderSpreadsheetList: (spreadsheets) ->
      $container = $('#spreadsheet-list ul#spreadsheets')
      $container.empty()
      html = SB.Templates.spreadsheets(spreadsheets)
      $(html).appendTo($container)
      $container.listview('refresh')
      $container.find('a').click (e) =>
        remoteUrl = $(e.currentTarget).attr('remote-url')
        @loadSpreadsheet remoteUrl

    loadSpreadsheet: (remoteUrl) ->
      url = @getFullUrl remoteUrl

      @numToLoad = 0
      @numLoaded = 0

      $.mobile.showPageLoadingMsg()
      $.ajax {
        url: url
        dataType: 'jsonp'
        success: (data) =>
          for entry in data.feed.entry
            @numToLoad++
            baseUrl = entry.link[1].href
            url     = @getFullUrl baseUrl
            @loadCells url
        error: ->
          $.mobile.hidePageLoadingMsg()
          alert 'Problem fetching data.'
      }

    loadCells: (url) ->
      $.ajax {
        url: url
        dataType: 'jsonp'
        success: (data) =>
          @numLoaded++

          items = []
          entries = data.feed.entry

          for i in [0..entries.length-1] by 2
            try
              items.push {
                'question': entries[i].content.$t
                'answer'  : entries[i+1].content.$t
              }
            catch error
              alert('Error in spreadsheet. Make sure it has only 2 columns: Question & Answer.')
              return

          @addToCategory data.feed.title.$t, items

          if @numLoaded is @numToLoad
            $.mobile.hidePageLoadingMsg()
            $.mobile.changePage($('#main'))
            SB.App.addCategories()

        error: ->
          $.mobile.hidePageLoadingMsg()
          alert 'Problem fetching cells from spreadsheet.'
      }

    addToCategory: (name, items) ->
      for category, i in SB.Data.categories
        if category.name is name
          SB.Data.categories.remove i, i
          break

      newCategory = {
        name: name
        items: items
      }

      SB.Data.categories.push newCategory
      localStorage.setItem 'categories', JSON.stringify(SB.Data.categories)

    authenticateUser: ->
      baseUrl        = 'https://accounts.google.com/o/oauth2/auth'
      responseType   = 'response_type=token'
      clientId       = 'client_id=483114445763.apps.googleusercontent.com'
      redirectUri    = 'redirect_uri=' + SB.Env.redirectUri
      scope          = 'scope=https://docs.google.com/feeds/%20https://docs.googleusercontent.com/%20https://spreadsheets.google.com/feeds/'

      parameters = "#{responseType}&#{clientId}&#{redirectUri}&#{scope}"
      fullUrl = "#{baseUrl}?#{parameters}"

      window.location = fullUrl

  SB.Templates =
    categories:   Handlebars.compile $('#category-list-template').html()
    question:     Handlebars.compile $('#question-template').html()
    spreadsheets: Handlebars.compile $('#spreadsheet-list-template').html()

  # kick this shit off
  SB.App.init()

# Handlebars helpers
Handlebars.registerHelper 'first', (context, options) ->
  context[0][options.hash.attr] or= context[0]

# sort method ripped from coffeescriptcookbook.com
Array::shuffle = -> @sort -> 0.5 - Math.random()

# array remove stolen from jresig's blog and converted to coffeescript
Array::remove = (from, to) ->
  rest = @.slice((to or from) + 1 or @.length)
  @.length = if from < 0 then @.length + from else from
  @.push.apply @, rest

return
