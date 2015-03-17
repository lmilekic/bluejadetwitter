# bluejade
_a nanoTwitter project._


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

__user_following_users__
_many_to_many_

field | data type
----- | -----
id | integer
user_id | integer
followed_user_id | integer
