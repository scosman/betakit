
var Betakit = Betakit || {};

// helper from http://stackoverflow.com/questions/1403888/get-url-parameter-with-jquery
Betakit.getURLParameter = function (name) {
  return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search)||[,""])[1].replace(/\+/g, '%20'))||null;
};

// runs right away, saves referral code to cookie
(function() {
  // check if the url contains a bkref (Betakit Referral Code)
  var ref = Betakit.getURLParameter("bkref");
  if (!ref) return;

  // Save to a cookie to allow tracking referrals
  document.cookie = "BetakitReferralCode=" + encodeURIComponent(ref) + ";path='/'";
}());

Betakit.getReferralCode = function()
{
  var refFromUrl = Betakit.getURLParameter("bkref");
  if (refFromUrl) return refFromUrl;

  var cookies = document.cookie.split('; ');
  for (var i = 0, parts; (parts = cookies[i] && cookies[i].split('=')); i++) {
    if (parts.shift() === "BetakitReferralCode") {
      return decodeURIComponent(parts.join('='));
    }
  }
}

// TODO P1 - Move this to a JST
Betakit.getShareHtml = function(shareLink)
{
  var shareSection = "<div class='betakitShareTitle'>Thank you!</div>";
  shareSection += "<div class='betakitShareSubtitle'>We'll send you an invite soon.</div>";
  shareSection += "<div class='betakitShareSection'>Share</div>";
  
  // HTML for the share section (AddThis.com's sharing widget)
  shareSection += '<script type="text/javascript">\n  var addthis_share ={};\n  var Betakit = Betakit || {};\n  addthis_share.url = "' + shareLink + '";\n  if (Betakit.shareTitle != undefined) addthis_share.title = Betakit.shareTitle;\n  if (Betakit.shareDescripton != undefined) addthis_share.description = Betakit.shareDescripton;\n  if (Betakit.shareTwitterTemplate != undefined) \n  {\n    addthis_share.templates = {}; \n    addthis_share.templates.twitter = Betakit.shareTwitterTemplate;\n  }\n</script>\n\n<!-- AddThis BEGIN -->\n<div id="shareButtonGroup" class="addthis_toolbox addthis_default_style addthis_32x32_style">\n<a class="addthis_button_twitter"></a>\n<a class="addthis_button_facebook"></a>\n<a class="addthis_button_linkedin"></a>\n<a class="addthis_button_google_plusone_badge"></a>\n<a class="addthis_button_email"></a>\n<a class="addthis_button_compact"></a>\n</div>\n';
  
  // HTML for the Follow section, ensure at least 1 is set
  if (Betakit.facebookName || Betakit.twitterUser || Betakit.rssLink)
  {
    shareSection += '<div class="betakitShareSection">Follow Us</div><div class="addthis_toolbox addthis_32x32_style addthis_default_style">';
    if (Betakit.twitterUser)
    {
      shareSection += '<a class="addthis_button_twitter_follow" addthis:userid="' + Betakit.twitterUser + '">';
    }
    if (Betakit.facebookName)
    {
      shareSection += '<a class="addthis_button_facebook_follow" addthis:userid="' + Betakit.facebookName + '"></a>' 
    }
    if (Betakit.rssLink)
    {
      shareSection += '<a class="addthis_button_rss_follow" addthis:url="' + Betakit.rssLink + '"></a>'; 
    }
    shareSection += '</div>';
  }
  shareSection += '<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#pubid=xa-500974530091d712"></script>\n<!-- AddThis END -->';

  // HTML for the referral Link Section
  if (!Betakit.hideReferralLink)
  {
    shareSection += "<div class=\"betakitShareSection\">Referral Link</div>Share this link for referral credit:";
    shareSection += "<a target='_blank' class='betakitShareLink' href='" + shareLink  + "'>" + shareLink + "</a>"
  }

  return shareSection;
};

Betakit.shareClicked = function(event)
{
  $.ajax({
    url: Betakit.url + "/api/increment_stat", 
    dataType: "jsonp",
    data: {email: Betakit.userEmail, stat: "share_clicked"},
    success: function(data, textStatus, xhr){}, // Nothing to do :|
  });
}

Betakit.generateShareLink = function(referralCode)
{
  // Use the configured url, if missing, current url
  var baseUrl = Betakit.shareUrl || location.href;

  // remove any old "bkref" parameters, if present
  var match = (new RegExp('[?|&]bkref=' + '([^&;]+?)(&|;|$)').exec(baseUrl));
  if (match)
  {
    // substring(1)  because we want to leave the leading ? or &
    baseUrl = baseUrl.replace(match[0].substring(1), "");
  }

  // add the refcode
  baseUrl += (baseUrl.indexOf("?") == -1 ? "?" : "&");
  baseUrl += "bkref=" + referralCode;

  return baseUrl;
}

Betakit.signUp = function()
{
  $('#betakitErrorArea').html("");
  var email = $('#betakitEmail').val();
  var emailRegex = /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i;
  var validEmail = emailRegex.test(email);
  var referralCode = Betakit.getReferralCode();

  if (!validEmail)
  {
    $('#betakitErrorArea').html("Please enter a valid email address");
    return;
  }
  
  $('#betakitButton').attr("disabled", true);
  $('#betakitErrorArea').html("Signing up...");

  $.ajax({
    url:Betakit.url + "/api/request_invite?email=" + encodeURIComponent(email) + "&referral_code=" + referralCode,
    dataType: "jsonp",
    success: function(data, textStatus, xhr)
      {
        if (data.error)
        {
          this.error(xhr, textStatus, data.error);
          return;
        }

        $('#betakitSection').fadeOut(300, function()
          {
            // save for stats reporting (share clicks)
            Betakit.userEmail = email;
            
            // generate link to share
            var shareLink = Betakit.generateShareLink(data.referralCode);
            $('#betakitSection').html(Betakit.getShareHtml(shareLink));
            $('#betakitSection').slideDown();
            $('#shareButtonGroup > a').click(Betakit.shareClicked);
          });
      },
    timeout: 10000,
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

