# Specifications for the Sinatra Assessment

## Specs:
- [x] Use Sinatra to build the app
    * ➡️ This app is built with Sinatra framework.

- [X] Use ActiveRecord for storing information in a database
    * ➡️ This app uses [ActiveRecord](https://github.com/rails/rails/tree/master/activerecord) to map classes to relational database tables, class associations are defined in app/models.

- [X] Include more than one model class (list of model class names e.g. User, Post, Category)
    * ➡️ This app contains three classes: ```User, Course, UserCourse```.

- [X] Include at least one has_many relationship 
    * ➡️ User has_many ```courses``` and ```userCourses```.

- [X] Include user accounts
    * ➡️ A user can create her account, either as a student or as an instructor.

- [X] Ensure that users can't modify content created by other users
    * ➡️ A user who is an ```instructor``` can edit the courses she is teaching and student enrollment status. 

    A user who is a ```student``` can edit the courses she is registered for. 

    All users can edit their personal account information!

- [X] Include user input validations
    * ➡️ User input validates are both defined in their model definitions, and validated in forms where certain inputs are required. 

    For example, the ```Course``` model validates ```:instructor_id, :name, :description, :level```. These attributes also validated in the ```courses/new``` form, where ```course name, description, level``` are required inputs.


- [X] Display validation failures to user with error message
    * ➡️ Validation messages are displayed using ```rack-flash3``` Ruby Gem. 

    For example, when a new user sign-up for an account, an error message will be displayed if they do not complete all required fields accurately:
    ```Please ensure you have filled in all required fields correctly!``` 

- [X] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code
    * ➡️ This app's ```README file``` includes all required descriptions.

## Confirm:
- [X] You have a large number of small Git commits
    * ➡️ This repo currently has 75 commits

- [X] Your commit messages are meaningful
    * ➡️ All commit messages are descriptive of the changes made, and the corresponding files changes are made in./

- [X] You made the changes in a commit that relate to the commit message
    * ➡️ Changes made in each commit correspomds to the commit message

- [X] You don't include changes in a commit that aren't related to the commit message
    * ➡️ Yes


## Stuff To Add:
- [] Navigation system 
    * Navbar 
        -> If ! logged_in show signup and login 
        -> I logged in show links to /courses and /courses/new and logout
    * Notifications
        -> Make sure the notification states the right thing.