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
        return this.nextQuestion(bank, 0);
      },
      nextQuestion: function(bank, index) {
        var $contentEl, context, html, item,
          _this = this;
        context = {
          question: bank[index][0],
          answer: bank[index][1]
        };
        $contentEl = $('#quiz #content');
        $contentEl.empty();
        html = SB.Templates.question(context);
        item = $(html).appendTo($contentEl);
        item.collapsible();
        $('#quiz #question-count').text(bank.length + ' remaining');
        $('#quiz #shuffle-btn, #quiz #got-it-btn, #quiz #next-question-btn').unbind('click');
        $('#quiz #shuffle-btn').click(function(e) {
          bank.shuffle();
          return _this.nextQuestion(bank, 0);
        });
        $('#quiz #got-it-btn').click(function(e) {
          bank.remove(index);
          if (bank.length === 0) {
            return _this.quizComplete();
          } else {
            return _this.nextQuestion(bank, index);
          }
        });
        return $('#quiz #next-question-btn').click(function(e) {
          index++;
          if (index === bank.length) index = 0;
          return _this.nextQuestion(bank, index);
        });
      },
      quizComplete: function() {
        alert('Nice job!');
        return $.mobile.changePage($('#main'));
      }
    };
    SB.Templates = {
      categories: Handlebars.compile($('#category-list-template').html()),
      question: Handlebars.compile($('#question-template').html())
    };
    return SB.App.init();
  });

  Array.prototype.shuffle = function() {
    return this.sort(function() {
      return 0.5 - Math.random();
    });
  };

  Array.prototype.remove = function(from, to) {
    var rest;
    rest = this.slice((to || from) + 1 || this.length);
    this.length = from < 0 ? this.length + from : from;
    return this.push.apply(this, rest);
  };

  return;

}).call(this);
