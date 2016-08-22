# Forever Challenge
Please create a fork of this project and fulfill the requirements below.  Upon completion, please send Forever a link to your fork.

If you need to make an assumption about a vague requirement, feel free to do so, but please state that assumption at the bottom of this Readme.  Try to fulfill all of the requirements as if this application is going to be deployed into the real world with heavy usage.


# Requirements
1. Add basic API actions (index, show, create, update and destroy) to the albums_controller and photos_controller.
2. The albums index actions should return JSON with all available fields for the record AND a field for the total number of photos in the album.
3. The API index actions should use pagination with a max of 10 items per page and accept a param to iterate through pages.
4. An album's show action should return data for each photo in the album.
5. Ensure that every album has a name.
6. Ensure that every photo record belongs to an album, has a name and a url that ends with the string ".jpeg" or ".jpg".
7. Ensure that no more than 60 photos can be added to an album.
8. Create or modify a controller action so that multiple photos can be added to an album from one request.
9. Ensure that an album's average_date field is always the average taken_at date of all associated photos (or nil if the album has no photos).


# Bonus (only for senior developers)
1. Allow the API to add videos to an album.  The album index action should return a combination of photos and videos.
2. Allow photos to be added to multiple albums.


# Tech Specs
Rails 4.2.6

SQLite is preferred. Postgres is ok.

Anything can be changed if you think it's needed, including the gemfile, database schema, configs, etc.


# Getting Started
Run `bundle install` and `rake db:migrate`.

You can populate your database with fake data by running `rake db:seed`.

# Assumptions
 * Probably want to destroy all photos associated with an album if an album is destroyed
 * Not storing actual images, just URLs
 * I'm assuming we don't need full api endpoints with an `/api` route, etc. Just writing out the controller actions and routes as though it's an app, but only renders JSON.
 * I did not add a test for the #show action of the photos controller because there weren't any requirements around it aside from showing the photo, which is silly to test.
 * It seems to me that the "position" attribute on album is entirely unused, so I am going to ignore it.
 * As much as we're allowing the API to _add_ multiple photos at a time, I am assuming we are still only destroying one at a time.
