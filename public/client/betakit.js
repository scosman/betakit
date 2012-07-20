
var Betakit = Betakit || {};

Betakit.getShareHtml = function()
{
  var shareSection = "<div class='betakitShareTitle'>Thank you!</div>";
  shareSection += "<div class='betakitShareSubtitle'>We'll send you an invite soon.</div>";
  shareSection += "<div class='betakitShareSection'>Share</div>";
  // JST for the share section (AddThis.com's sharing widget)
  var JST = function(obj){var __p=[],print=function(){__p.push.apply(__p,arguments);};with(obj||{}){__p.push('<script type="text/javascript">\n  var addthis_share ={};\n  var Betakit = Betakit || {};\n  if (Betakit.shareUrl != undefined) addthis_share.url = Betakit.shareUrl;\n  if (Betakit.shareTitle != undefined) addthis_share.title = Betakit.shareTitle;\n  if (Betakit.shareDescripton != undefined) addthis_share.description = Betakit.shareDescripton;\n  if (Betakit.shareTwitterTemplate != undefined) \n  {\n    addthis_share.templates = {}; \n    addthis_share.templates.twitter = Betakit.shareTwitterTemplate;\n  }\n</script>\n\n<!-- AddThis BEGIN -->\n<div id="shareButtonGroup" class="addthis_toolbox addthis_default_style addthis_32x32_style">\n<a class="addthis_button_twitter"></a>\n<a class="addthis_button_facebook"></a>\n<a class="addthis_button_linkedin"></a>\n<a class="addthis_button_google_plusone_badge"></a>\n<a class="addthis_button_email"></a>\n<a class="addthis_button_compact"></a>\n</div>\n<div class="betakitShareSection">Follow Us</div>\n<div class="addthis_toolbox addthis_32x32_style addthis_default_style">\n<a class="addthis_button_facebook_follow" addthis:userid="ShoeboxApp"></a>\n<a class="addthis_button_twitter_follow" addthis:userid="getshoebox"></a>\n<a class="addthis_button_rss_follow" addthis:url="http://blog.couchlabs.com/rss"></a>\n</div>\n<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#pubid=xa-500974530091d712"></script>\n<!-- AddThis END -->\n');}return __p.join('');};
  shareSection += JST();

  return shareSection;
};

Betakit.shareClicked = function(event)
{
  $.get("/api/increment_stat", {email: Betakit.userEmail, stat: "share_clicked"});
}

Betakit.signUp = function()
{
  $('#betakitErrorArea').html("");
  var email = $('#betakitEmail').val();
  var emailRegex = /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i;
  var validEmail = emailRegex.test(email);

  if (!validEmail)
  {
    $('#betakitErrorArea').html("Please enter a valid email address");
    return;
  }
  
  $('#betakitButton').attr("disabled", true);
  $('#betakitErrorArea').html("Signing up...");

  $.ajax({
    url:Betakit.url + "/api/request_invite?email=" + encodeURIComponent(email),
    success: function(data, textStatus, xhr)
      {
        $('#betakitSection').fadeOut(300, function()
          {
            Betakit.userEmail = email;
            $('#betakitSection').html(Betakit.getShareHtml());
            $('#betakitSection').slideDown();
            $('#shareButtonGroup > a').click(Betakit.shareClicked);
          });
      },
    error: function(xhr, textStatus, error)
      {
        $('#betakitErrorArea').html("There was a problem. Please try again.");
        $('#betakitButton').attr("disabled", false);
      },
  });
};

$(document).ready(function() {
  $('#betakitButton').click(Betakit.signUp)
  $('#betakitEmail').keypress(function(e){
    if(e.which == 13){
      Betakit.signUp();
    }
  });
});

