
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
    $('[inviteSection="' + email + '"]').html("sending email... you better hope they like it");

    $.ajax({
      url: "/api/invite_user?email=" + email,
      success: function(data, textStatus, xhr)
        {
          $('[inviteSection="' + email + '"]').html("invite sent. time to pray");
        },
      error: function(xhr, tStatus, error)
        {
          $('[inviteSection="' + email + '"]').html("hmmmm, there may have been a problem...");
        },
    });
    alert('invite');
  } 

});

$(window).load(function(){
  // start backbone
  new AdminHomeView(); 
});

