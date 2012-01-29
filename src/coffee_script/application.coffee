SB = {}

$ ->

  SB.Data = {
    categories: JSON.parse(localStorage.categories)
  }

  SB.Credentials = {}

  SB.App =
    init: ->
      @checkHashForAuth()

      if SB.Data.categories
        @addCategories()
      else
        SB.Data.categories = []
        @loadSpreadsheets()

      # listen for page loads and act as router
      $(document).bind 'pagechange', @onPageChange

    checkHashForAuth: ->
      return if location.hash.indexOf('access_token') is -1

      params = location.hash.split('&')
      params[0] = params[0].split('#')[1]
      SB.Credentials = {}

      for param in params
        param = param.split('=')
        SB.Credentials[param[0]] = param[1]

      $.mobile.changePage($('#spreadsheet-list'))


    onPageChange: (e, data) =>
      switch location.hash
        when '#quiz' then SB.App.startQuiz()
        when '#spreadsheet-list' then SB.App.loadSpreadsheets()

    addCategories: ->
      # add an index to each data item
      for index, category of SB.Data.categories
        category['index'] = index

      $container = $('#main #categories')
      $container.empty()
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

      return

    quizComplete: ->
      alert 'Nice job!'
      $.mobile.changePage($('#main'))

    loadSpreadsheets: ->
      if not SB.Credentials.access_token
        @authenticateUser()
        return

      baseUrl = 'https://spreadsheets.google.com/feeds/spreadsheets/private/full'
      accessToken = "access_token=#{SB.Credentials.access_token}"
      alt     = 'alt=json-in-script'
      url     = "#{baseUrl}?#{accessToken}&#{alt}"

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

    renderSpreadsheetList: (spreadsheets) ->
      $container = $('#spreadsheet-list ul#spreadsheets')
      html = SB.Templates.spreadsheets(spreadsheets)
      $(html).appendTo($container)
      $container.listview('refresh')
      $container.find('a').click (e) =>
        remoteUrl = $(e.currentTarget).attr('remote-url')
        @loadSpreadsheet remoteUrl

    loadSpreadsheet: (remoteUrl) ->
      # TODO: abstract this. duplicated
      accessToken = "access_token=#{SB.Credentials.access_token}"
      alt     = 'alt=json-in-script'
      url     = "#{remoteUrl}?#{accessToken}&#{alt}"

      $.mobile.showPageLoadingMsg()
      $.ajax {
        url: url
        dataType: 'jsonp'
        success: (data) =>
          for entry in data.feed.entry
            baseUrl = entry.link[1].href
            url     = "#{baseUrl}?#{accessToken}&#{alt}"
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
          $.mobile.hidePageLoadingMsg()

          items = []
          entries = data.feed.entry

          for i in [0..entries.length-1] by 2
            try
              # TODO: get this into a better format -- question/answer, etc
              items.push [entries[i].content.$t, entries[i+1].content.$t]
            catch error
              console.log error
              alert('Error in spreadsheet. Make sure it has only 2 columns: Question & Answer.')
              return

          @addToCategory data.feed.title.$t, items
          $.mobile.changePage($('#main'))
          SB.App.addCategories()

        error: ->
          $.mobile.hidePageLoadingMsg()
          alert 'Problem fetching cells from spreadsheet.'
      }

    addToCategory: (name, items) ->
      # append to existing category or create new
      categoryExists = false

      for category in SB.Data.categories
        if category.name is name
          category.items = category.items.concat(items)
          categoryExists = true

      if not categoryExists
        newCategory = {
          name: name
          items: items
        }

        SB.Data.categories.push newCategory
        localStorage.setItem 'categories', JSON.stringify(SB.Data.categories)

      # TODO: save to local storage

    authenticateUser: ->
      baseUrl        = 'https://accounts.google.com/o/oauth2/auth'
      responseType   = 'response_type=token'
      clientId       = 'client_id=483114445763.apps.googleusercontent.com'
      redirectUri    = 'redirect_uri=http://localhost:8888'
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
