
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

  invite: function(event) {
    var email = $(event.target).attr("email");

    $.ajax({
      url: "/api/invite_user?email=" + email,
    });
    alert('invite');
  } 

});

$(window).load(function(){
  // start backbone
  new AdminHomeView(); 
});

