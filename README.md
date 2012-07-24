Betakit
=======

A simple, powerful and hackable service for running a beta release with invite codes. Betakit includes a "request an invite" widget, social sharing, referral tracking, invite code generation, invite mailer and an admin interface.

Preview
-------

![Share widget](https://s3.amazonaws.com/www.couchlabs.com/downloads/marketing/share.png)
![Admin Console](https://s3.amazonaws.com/www.couchlabs.com/downloads/marketing/admin.png)

Functionality
-------------
* Collect invite requests from users
* Email user beta invites with a personal invite code
* Share widget to increase traffic to your beta
* Referral tracking
* Social media sharing tracking
* Admin console to review progress and invite users
* Import existing beta lists from other providers \(LaunchRock, Prefinery, Gmail, etc\)
* Export emails 
* Easy to hack/modify to meet your needs 
* Designed for Heroku, deploy your own service in minutes

Setup
-----

Betakit is designed to be run on your own server, it is not a hosted service. However, it's very easy to get up and running on any Rails host, and designed to be simple to deploy to Heroku (which is free).

These steps assume you want to deploy to Heroku. You can ignore Heroku specific steps and deploy anywhere you want.

### Step 1: Clone Betakit

    git clone https://github.com/scosman/betakit.git
    cd betakit

### Step 2: Create a heroku app and deploy Betakit

    heroku create YOUR_HEROKU_APP
    git push heroku master

You can now access betakit at https://YOUR\_HEROKU\_APP.herokuapp.com

You'll be prompted for a password which you don't know, that's because you are not done the setup.

### Step 3: Create the database

    heroku run rake db:migrate

### Step 4: Server Setup

There are a number of environment variables you must set for betakit to function. They are null by default for security

    heroku config:add admin_username="ADMIN_USERNAME"
    heroku config:add admin_password="ADMIN_PASSWORD"
    heroku config:add app_secret="A longish secret string, can be anything"
    heroku config:add email_from_address="welcome@yourdomain.com" 
    heroku config:add email_invite_subject="Your PRODUCT NAME Account Is Ready"
    
Try signing in with the credentials you just set. Betakit is ready to start tracking your beta.

### Step 5: Request an Invite Widget 

Now it's time to embed a "request an invite" widget onto your page. Want to try the widget before you install it? Go to http://YOUR\_HEROKU\_APP.herokuapp.com/client/clientTestPage.html

If you want to create your own submission form, go ahead and skip this step. See the API section at the bottom for details and betakit.js for a sample.

To install the widget, paste the code block below into your marketing website.

IMPORTANT: be sure to set YOUR\_HEROKU\_APP in the code you copy and paste to the app you created in step 2.

```html
    <link href="http://YOUR_HEROKU_APP.herokuapp.com/client/betakit.css" rel="stylesheet" type="text/css">
    <div id="betakitSection">
      <input type="text" id="betakitEmail" placeholder="Email Address" />
      <input type="button" value="Sign Up" id="betakitButton" />
      <div id="betakitErrorArea"></div>
      <script type="text/javascript">
        var Betakit = Betakit || {};
        // REQUIRED URL of your Betakit service
        Betakit.url = "http://YOUR_HEROKU_APP.herokuapp.com";
        
        // Optional values to customize how the page is shared
        // I also suggest you add facebook OG tags https://developers.facebook.com/docs/opengraphprotocol/
        // Betakit.shareUrl = "http://someUrlOtherThanCurrentPage.com";
        // Betakit.shareTitle = "Product name";
        // Betakit.shareDescripton = "product description";
        // Betakit.shareTwitterTemplate = "Default msg for tweeting. {{url}} (via @yournamehere)";
        
        // Optional values to allow people to "Follow" your team/product. Section will only appear if at least 1 is set
        //Betakit.facebookName = "ShoeboxApp"; // Your companies Facebook name (facebook.com/YOUR_NAME)
        //Betakit.twitterUser = "getshoebox"; // Twitter name to follow (@username)
        //Betakit.rssLink = "http://blog.couchlabs.com/rss";  // link to a RSS feed (usually product blog)
        
        // Optional setting to hide the referral link section
        // Betakit.hideReferralLink = true; // Hides the "Referral Link" section on the share screen
      </script>
      <!-- REQUIRED: path to your own hosted version of Betakit -->
      <script src="http://YOUR_HEROKU_APP.herokuapp.com/client/betakit.js" type="text/javascript"></script> 
```

The CSS is designed to adopt the style of the page it's embedded in, but if your want more control, make a copy of betakit.css and tweak anything you like.

I suggest you uncomment and set all of the optional variables. The more details you provide, the better the share screen will be.

IMPORTANT: if you set Betakit.shareUrl, referral counting will break unless the url you set also includes the following in its head section:
```html
<script src="http://YOUR_HEROKU_APP.herokuapp.com/client/betakit.js" type="text/javascript"></script>
```

IMPORTANT: If you don't already use jQuery, include it in the head of your html document:
```html
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js" type="text/javascript"></script>
```

Test it out! The widget will take your email and show you sharing links. Refresh the admin console and you will see any users you added using the widget.

You can now deploy your marketing website.

### Step 6: Import existing users

In the admin console, import any existing users waiting for invites by clicking "Import Emails".

### Step 7: Setup invite codes and invite emails

Betakit makes it easy to email your users personal invite codes. To set it up we need a SMTP server (gmail.com works) and an email template.

To setup SMTP using gmail.com for Gmail or Google Apps custom domain emails (limited to 500 emails a day. Gmail changes the from address to your email address, despite configuration in step 4):

    heroku config:add smtp_user="YOUREMAIL@gmail.com"
    heroku config:add smtp_password="YOURGMAILPASSWORD"

To setup a custom SMTP server (sendgrid has free and paid plans):

    heroku config:add smtp_user="YOUR_SMTP_USERNAME"
    heroku config:add smtp_password="YOUR_SMTP_PASSWORD"
    heroku config:add smtp_server="YOUR_SMTP_SERVER"
    heroku config:add smtp_port="YOUR_SMTP_PORT"
    heroku config:add smtp_domain="YOUR_SMTP_DOMAIN"
    heroku config:add smtp_auth="YOUR_SMTP_AUTH_METHOD" // optional, defaults to "plain"

Next you need an email to send users. We've included a template you can start from:

    cp app/views/beta_mailer/invite_mail_development.html.erb app/views/beta_mailer/invite_mail_production.html.erb

Now edit the file app/views/beta_mailer/invite_mail_production.html.erb to make an awesome message to welcome new users. Open it in a browser to preview the html. Don't forget to leave `<%= @inviteCode %>` and `<%= @user.email %>`, these will be replaced with the user's invite code and email respectively.

When you are done, deploy the template:

    git add app/views/beta_mailer/invite_mail_production.html.erb
    git commit -m "Email invite template"
    git push heroku master

You can now go the the admin console and send invite emails. I suggest you test it with your own email first to make sure the template and SMTP settings are working.

### Step 8: Integrate with your app

The final step is to integrate the invite code in your app. Just verify the code when the user creates an account. Since the invite code is a SHA1 hash calculated from your secret and the user's email, it can be checked offline and in any programming language.

    pseudocode:
    invite_code = SHA1(app_secret + lowercase(email)).substring(0,7)

```ruby
  invite_code = Digest::SHA1.hexdigest("YOUR_APP_SECRET" + email.downcase)[0,8]
  if (invite_code != params[:invite]) render :text => "Unauthorized", :status => 401
  # process valid user signup
```

API
---

The following endpoints are available for direct integration.

    /api/request_invite?email=email%40email.com&referral_code=OPTIONAL&callback=jsonpCallback
    descrition: requests an invite
    returns: jsonpCallback({referralCode: "value"});
    errors: jsonpCallback({error: "errorMsg"});

    /api/increment_stat?email=email%40email.com&stat=STAT_NAME&callback=jsonpCallback
    description: increments a named stat. Used for "share_clicked" but call with anything to track user data.
    returns: jsonpCallback({status: "OK"});
    errors: jsonpCallback({error: "errorMsg"});

Contributions
-------------

Created by Steve Cosman. Feel free to send pull requests or make suggestions using github.

Products using Betakit
----------------------
* [Shoebox](http://shoeboxapp.com) - Original Project. Unlimited free photo backup you can access from anywhere.

Using Betakit? send a pull request updating this README.
