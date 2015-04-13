# EasyComments
[![Gem Version](https://badge.fury.io/rb/easycomments.svg)](http://badge.fury.io/rb/easycomments)
[![Build Status](https://travis-ci.org/zisismaras/easycomments.svg?branch=master)](https://travis-ci.org/zisismaras/easycomments)  


EasyComments(EC) is an easy to use comment system with a simple api
for posting and retrieving comments.It also comes bundled with a dashboard
for moderating your comments.

##Installing
Install by cloning the repository or for convenience install the gem
```ruby
gem install easycomments
```
and then(if you installed the gem) in a directory run
```ruby
ec install
```
(pass the --dev flag if you also want the spec suite)  
Then
```
bundle install --without test development  
or just  
bundle install  
if --dev is on
```
and you are ready.
##Configuring
Edit _config.yml to add your database (all adapters supported by sequel can be used)
and change any other option you need.
Then run
```ruby
rake init
```
to build the table and then
```ruby
rake adduser
```
to add your user.

##Endpoints
EC has one endpoint for posting a new comment and one for retrieving a comment list.
```
GET /comments, with a 'post' parameter and an optional 'page' parameter if you have pagination enabled.
```
The 'post' parameter simply serves as a namespace to group comments for retrieval,
it can be a blog post title, an url or something more sophisticated, it's up to you.

```
POST /comment, with parameters : post, name, email, body
```
Example client can be found here : [easycomments-polymer](https://github.com/zisismaras/easycomments-polymer)

##Dashboard
EC comes bundled with a dashboard (can be accessed at /dashboard) to moderate your
comments like approving, deleting, editing or ignoring.
It's build with [polymer](https://www.polymer-project.org) and [webcomponents](http://webcomponents.org/)

##Configuration options
in _config.yml you can change the following
```ruby
#database connection url to be passed to sequel's connect method.
#check http://sequel.jeremyevans.net/rdoc/files/doc/opening_databases_rdoc.html
#all adapters supported by sequel can be used
#you can also use an enviroment variable formatted as ENV["variable"] or just "variable" holding your db's url
connection: "sqlite://blog.db"

#set to true to allow all coments to be posted without moderation.
approve_by_default: false

#set to true to allow comments without a name.
allow_anonymous_post: false

#datetime format to be passed to strftime.
#see availabe options here http://ruby-doc.org/core-2.2.1/Time.html#method-i-strftime
timestamp_format: "%d/%m/%Y - %H:%M"

#set to true to enable cross-origin resource sharing.
allow_cors: false

#see available formats here https://github.com/cyu/rack-cors
cors_origin: "*"  

#set to false to not automatically escape html in comment bodies
auto_escape_html: true

#set to true to have pagination support in comment retrieval  
paginate: false  

#how many comments to return per page if paginate is true  
comments_per_page: 10
```

## Updating
If you installed easycomments as a gem there is a 'ec update' command.
It will recopy all the files but keeps your _config.yml and Gemfile.  
(--dev flag is available to also copy the spec suite)

## Rake tasks
'rake init' creates the required table.  
'rake update' run it after re-editing _config.yml to update the table.  
'rake adduser' you should always run this and not adding new users in _config.yml  
by hand since it also bcrypts your passwords!

##TODO:
* markdown support  
* dynamic fields in POST /comment  

## Contributing
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

###Tested with
* Ruby 2.2.1
* Ruby 2.1.5
* Ruby 2.0.0

###Licensed under MIT.

