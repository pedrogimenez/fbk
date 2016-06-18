# FBK

[![Build Status](https://img.shields.io/travis/pedrogimenez/fbk/master.svg)](https://travis-ci.org/pedrogimenez/fbk)

Just a bunch of methods that may come in handy when interacting with the Facebook Graph API.

We use this gem at [Chicisimo](https://github.com/chicisimo).

## Usage

```ruby
require "sinatra"
require "fbk"

REDIRECT_URI = "https://something.com/login/fb/token"

FBK.configure do |config|
  config.client_id     = "xxx"
  config.client_secret = "xxx"
end

get "/login/fb" do
  redirect to(FBK.authorize_uri(redirect_uri: REDIRECT_URI, scope: %w{public_profile}))
end

get "/login/fb/token" do
  code = params[:code]

  access_token = FBK.get_access_token(redirect_uri: REDIRECT_URI, code: code) # => "xxxx"

  user = FBK.get_user_info(access_token) # => {:id=>"xxxx", :first_name=>"Pedro", :gender=>"male", :last_name=>"Giménez", :link=>"https://www.facebook.com/pedrotgimenez", :locale=>"en_US", :name=>"Pedro Giménez", :timezone=>1, :updated_time=>"1955-02-24T00:00:00+0000", :username=>"pedrotgimenez", :verified=>true}

  friends = FBK.get_user_friends(access_token) # => => ["xxxx", "xxxx"]

  picture = FBK.get_user_picture(access_token, type: "square", height: 256) # => {:height=>320, :is_silhouette=>false, :url=>"https://scontent.xx.fbcdn.net/hprofile-xft1/v/t1.0-1/p320x320/xxxx.jpg", :width=>320}
end
```
