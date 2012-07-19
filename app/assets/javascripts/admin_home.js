
var AdminHomeView = Backbone.View.extend({

  el: 'body',

  initialize: function(options)
  {
    this.render();
  },

  events: {
    "click .inviteBtn": "invite",
  },

  render: function() {
  },

  invite: function() {
    alert('invite');
  } 

});

$(window).load(function(){
  // start backbone
  new AdminHomeView(); 
});

