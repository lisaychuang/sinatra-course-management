# Sinatra Course Management app

This app was built with Sinatra, extended with [Rake tasks](https://github.com/ruby/rake) for working with an SQL database using [ActiveRecord ORM](https://github.com/rails/rails/tree/master/activerecord). 

The course management app provides a database and web interface for users to:
* Sign up as a student or instructor
* Users can review all courses and users available
* Each user can **ONLY** modify content of their own course/registration:
    * An instructor can create, read, update, and delete (CRUD) a course
    * A student can create, read, update, and delete (CRUD) a course registration
* User inputs are validated for account/course/registration creation

## Model Classes
There are three model classes: ```User, Course, UserCourse```

1. User: stores user attributes, including:
    * Full Name
    * Username
    * Email
    * Password (Secured with [Bcrypt](https://github.com/codahale/bcrypt-ruby) hashing algorithm)
    * Biography
    * Instructor, a boolean value to indicate if a user is an instructor

2. Course: stores course attributes, including:
    * Name
    * Descirption
    * Icon, a string value that is commonly an emoji 📚
    * Level, indicates course difficulty (Beginner == 0, Intermediate == 1, Advance == 2)
    * Instructor_id, to associate course with an instructor

3. UserCourse: stores student course registrations attributes, including: 
    * Confirmation, indicates registration status (Pending == 0, Waitlist == 1, Enrolled == 2)
    * Notes, student's request to enroll in a course
    * User_id, to associate registration with a student
    * Course_id, to associate registration with a course

