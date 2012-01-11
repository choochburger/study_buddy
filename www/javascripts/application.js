(function() {

  $(function() {
    SB.App = {
      init: function() {
        return this.addCategories();
      },
      addCategories: function() {
        var $container, category, context, index, obj;
        index = -1;
        context = (function() {
          var _results;
          _results = [];
          for (category in SB.Data) {
            index++;
            _results.push(obj = {
              index: index,
              name: category
            });
          }
          return _results;
        })();
        $container = $('#main #categories');
        $(SB.Templates.categories(context)).appendTo($container);
        return $('#main').trigger('create');
      }
    };
    SB.Templates = {
      categories: Handlebars.compile($('#category-list-template').html())
    };
    return SB.App.init();
  });

}).call(this);
