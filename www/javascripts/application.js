(function() {

  $(function() {
    SB.App = {
      init: function() {
        return this.addCategories();
      },
      addCategories: function() {
        var $ul, category, context, i, obj;
        context = (function() {
          var _ref, _results;
          _ref = SB.Data;
          _results = [];
          for (category in _ref) {
            i = _ref[category];
            _results.push(obj = {
              index: 0,
              name: category
            });
          }
          return _results;
        })();
        $ul = $('#main ul');
        $(SB.Templates.categories(context)).appendTo($ul);
        return $ul.listview('refresh');
      }
    };
    SB.Templates = {
      categories: Handlebars.compile($('#category-list-template').html())
    };
    return SB.App.init();
  });

}).call(this);
