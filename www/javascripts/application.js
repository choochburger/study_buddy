(function() {

  $(function() {
    SB.App = {
      init: function() {
        return this.addCategories();
      },
      addCategories: function() {
        return console.log(SB.Data);
      }
    };
    return SB.App.init();
  });

}).call(this);
