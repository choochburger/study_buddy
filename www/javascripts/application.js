(function() {

  $(function() {
    var _this = this;
    SB.App = {
      init: function() {
        this.addCategories();
        return $(document).bind('pagechange', this.onPageChange);
      },
      onPageChange: function(e, data) {
        switch (location.hash) {
          case '#quiz':
            return SB.App.startQuiz();
        }
      },
      addCategories: function() {
        var $container, category, html, index, _ref;
        _ref = SB.Data.categories;
        for (index in _ref) {
          category = _ref[index];
          category['index'] = index;
        }
        $container = $('#main #categories');
        html = SB.Templates.categories(SB.Data.categories);
        $(html).appendTo($container);
        return $('#main').trigger('create');
      },
      startQuiz: function() {
        var bank, category, index, inputEl, question, selected, _i, _j, _len, _len2, _ref;
        bank = [];
        selected = $('#main #categories input:checked');
        for (_i = 0, _len = selected.length; _i < _len; _i++) {
          inputEl = selected[_i];
          index = $(inputEl).attr('index');
          category = SB.Data.categories[index];
          _ref = category.items;
          for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
            question = _ref[_j];
            bank.push(question);
          }
        }
        return this.nextQuestion(bank[0], bank);
      },
      nextQuestion: function(question, bank) {
        var $contentEl, context, html, item;
        context = {
          question: question[0],
          answer: question[1]
        };
        $contentEl = $('#quiz #content');
        $contentEl.empty();
        html = SB.Templates.question(context);
        item = $(html).appendTo($contentEl);
        item.collapsible();
        return $('#quiz #question-count').text(bank.length + ' remaining');
      }
    };
    SB.Templates = {
      categories: Handlebars.compile($('#category-list-template').html()),
      question: Handlebars.compile($('#question-template').html())
    };
    return SB.App.init();
  });

}).call(this);
