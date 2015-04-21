# bluejade
This is our nanotwitter project! The creators of this project are Calvin Wang, Zach Hogan, Luka Milekic, and Clara Nice. Keeping to the requirements of the project we have done our best to  not only finish the bare minimum, but add some of our flare to the project.  As far as functionality, the basics are all available.  A user can tweet, follow other users, unfollow other users, see other users' profiles (and their own), and see their twitter feed.  In addition, whenn not logged in, there is a feed of the last 100 most recent tweets.  Using caching we have optimized this process and made it a much smoother process. Using active-record, our backend databases uses SQLite when run on a local machine and postgres when run on the production site. As far as our programming language and tool, we are using Ruby with Sinatra to build and run the server.
Sticking with RESTful design we are using HTTP requests to process messages whenever a user wants to do something. 

## schemas

__users__
_has_many tweets_

field | data type
----- | -----
id | integer
name | text
email | text
username | text
password | text
logged_in | boolean
password | text
logged_in | boolean

__tweets__

field | data type
----- | -----
id | integer
user_id | integer
text | text

__follow_connections__
_many_to_many_

field | data type
----- | -----
id | integer
user_id | integer
followed_user_id | integer
