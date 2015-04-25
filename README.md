# bluejade
This is our nanotwitter project! The creators of this project are Calvin Wang, Zach Hogan, Luka Milekic, and Clara Nice. Keeping to the requirements of the project we have done our best to  not only finish the bare minimum, but add some of our flare to the project.  As far as functionality, the basics are all available.  A user can tweet, follow other users, unfollow other users, see other users' profiles (and their own), and see their twitter feed.  In addition, whenn not logged in, there is a feed of the last 100 most recent tweets.  Using caching we have optimized this process and made it a much smoother process. Using active-record, our backend databases uses SQLite when run on a local machine and postgres when run on the production site. As far as our programming language and tool, we are using Ruby with Sinatra to build and run the server.
Sticking with RESTful design we are using HTTP requests to process messages whenever a user wants to do something. 

## Routes Explanation

`get '/'` - This returns either the welcome page or the homepage of BlueJade.  The welcome page is displayed when there is no user logged in.  This page gives the ability to login and create a new account.  In addition, it displays the latest 100 tweets made by anyone using BlueJade.  The homepage page displays the last hundred tweets by users the logged in user is following.  It also gives the logged in user the ability to tweet.

`post '/user/register'` - This registers a user into our database and sets the current session (cookies) to that user.  This then sends the user to their profile page or, if unsuccessful, back to the homepage.

`post '/login'` - If there is the user in the database, and the username and password match what is in the database, this will log the person into that account and sends the user to their homepage.  If the credentials do not match the data in the database it will keep the user in the welcome page for our application and let them know that the login was unsuccessful. 

`post '/tweet'` - This is our route for tweeting.  A user must be logged in and either on their homepage or profile page in order to tweet.  If these conditions are met, this will send a post request with the tweet and add it to the database.  If successful, the tweet will now appear in the user's profile page and in homepages of users following the user.

`post '/follow'` - Following is pretty simple in BlueJade.  While logged in, if a user goes to another user's page, there will be a button that says follow or unfollow depending on the status of whether the user is following the other.  Behind the scenes this will send a post to the database to our UserConnection table to record this relationship.

`post '/unfollow'` - This does the same thing as following, except it gets rid of that data in the database, terminating the relationship.

`get '/user'` - If there is a user logged in, this will send the user to their profile page, which will be '/user/:user'.  If there is no user logged in, this will just redirect you to the welcome page.

`get '/user/:user'` - Regardless of whether a user is logged in, this will display the profile of whoever :user is in the BlueJade database.  The profile page contains the last 100 tweets created by :user and, if you are logged in and this is not your profile, it gives the ability to follow/unfollow the user.  If it is your own profile, you have the ability to tweet and see the last 100 tweets you have created.

`get '/search'` - This get request sends the user to the /search route in BlueJade.  The user types in phrase and BlueJade automagically finds both tweets and users that correspond with each word in that phrase.  On the left side is a list of all tweets that fit the criteria and on the right side are users.

`get '/logout'` - This is the sad time of the day when the user has to log out of BlueJade.  User's always show remorse at this step so we make it quick.  This empties the current session (logs out of the account) and sends the user back to the welcome page to decide whether they want to continue on the most amazing application they have ever used, or do something else. Regardless, we always support the decisions of the user.

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
