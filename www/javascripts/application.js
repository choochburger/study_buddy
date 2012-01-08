(function() {

  $(function() {
    var addCategories;
    addCategories = function() {
      return $.ajax({
        url: 'data.json',
        dataType: 'json',
        success: function(data) {
          var category, name, _results;
          _results = [];
          for (category in data) {
            name = data[category];
            _results.push(console.log(name));
          }
          return _results;
        }
      });
    };
    return addCategories();
  });

}).call(this);
