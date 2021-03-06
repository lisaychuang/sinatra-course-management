require 'spec_helper'

describe ApplicationController do

  describe "Homepage" do
    it 'loads the homepage if user is not logged in' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Training on HOT topics")
    end
  end

  describe "Login" do
    it 'loads the login page' do
      get '/login'
      expect(last_response.status).to eq(200)
    end

    it 'does not let a logged in user view the login page' do
      user = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha")
      params = {
        :username => "nili678",
        :password => "iesha"
      }
      post '/login', params
      session = {}
      session[:user_id] = user.id
      get '/login'
      expect(last_response.location).to include("/courses")
    end
  end

  describe "Logout" do
    it "let a logged in user logout" do
      user = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha")
      params = {
        :username => "nili678",
        :password => "iesha"
      }
      post '/login', params
      get '/logout'
      expect(last_response.location).to include("/login")
    end

    it 'does not let a user logout if not logged in' do
      get '/logout'
      expect(last_response.location).to include("/")
    end
  end

  describe 'CREATE action' do
    context 'Create new user' do

      it 'loads the user signup page' do
        get '/signup'
        expect(last_response.status).to eq(200)
      end

      it 'does not let a user sign up without a full_name' do
        params = {
          :full_name => "",
          :username => "adri123",
          :email => "adri@example.com",
          :password => "stellenbosch"
        }
        post '/signup', params
        expect(last_response.location).to include('/signup')
      end

      it 'does not let a user sign up without a username' do
        params = {
          :full_name => "Adri Baard",
          :username => "",
          :email => "adri@example.com",
          :password => "stellenbosch"
        }
        post '/signup', params
        expect(last_response.location).to include('/signup')
      end

      it 'does not let a user sign up without an email' do
        params = {
          :full_name => "Adri Baard",
          :username => "adri123",
          :email => "",
          :password => "stellenbosch"
        }
        post '/signup', params
        expect(last_response.location).to include('/signup')
      end

      it 'does not let a user sign up without a password' do
        params = {
          :full_name => "Adri Baard",
          :username => "adri123",
          :email => "adri@example.com",
          :password => ""
        }
        post '/signup', params
        expect(last_response.location).to include('/signup')
      end

      it 'signup directs user to course index page' do
        params = {
          :full_name => "Adri Baard",
          :username => "adri123",
          :email => "adri@example.com",
          :password => "stellenbosch"
        }
        post '/signup', params
        expect(last_response.location).to include("/courses")
      end

      it 'does not let a logged in user view the signup page' do
        user = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha")
        params = {
          :username => "nili678",
          :password => "iesha"
        }
        post '/login', params
        session = {}
        session[:user_id] = user.id
        
        get '/signup'
        expect(last_response.location).to include("/courses")
      end
    end

  context 'Create new course' do
      it 'let a logged in user view new course form if she is an instructor' do
        user = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha", :instructor =>true)

        visit '/login'

        fill_in(:username, :with => "nili678")
        fill_in(:password, :with => "iesha")
        click_button 'Submit'

        visit '/courses/new'
        expect(page.current_path).to include('/courses')
      end

      it 'let a logged in user create a course if she is an instructor' do
        user = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha", :instructor => true)

        visit '/login'

        fill_in(:username, :with => "nili678")
        fill_in(:password, :with => "iesha")
        click_button 'Submit'

        visit '/courses/new'
        fill_in(:name, :with => "AMP")
        fill_in(:description, :with => "Learn to use AMP!")
        fill_in(:icon, :with => "🔥")
        fill_in(:level, :with => 0 )
        click_button 'Create Course'

        user = User.find_by(:username => "nili678")
        course = Course.find_by(:name => "AMP")
        expect(course).to be_instance_of(Course)
        expect(course.instructor_id).to eq(user.id)
        expect(page.status_code).to eq(200)
      end

      it 'does not let an instructor create a blank course' do
        user = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha", :instructor => true)

        visit '/login'

        fill_in(:username, :with => "nili678")
        fill_in(:password, :with => "iesha")
        click_button 'Submit'

        visit '/courses/new'

        fill_in(:name, :with => "")
        click_button 'Create Course'

        expect(Course.find_by(:name => "")).to eq(nil)
        expect(page.current_path).to eq("/courses/new")
      end

      it 'does not let a logged in user view new course form if she is a student' do
        user = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha", :instructor => false)

        visit '/login'

        fill_in(:username, :with => "nili678")
        fill_in(:password, :with => "iesha")
        click_button 'Submit'

        visit '/courses/new'
        expect(page.status_code).to eq(200)
      end
    end

    context 'logged out' do
      it 'does not let a user view new course form if not logged in' do
        user = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha", :instructor => true)

        visit '/login'

        fill_in(:username, :with => "nili678")
        fill_in(:password, :with => "iesha")
        click_button 'Submit'

        visit '/logout'

        visit '/courses/new'
        expect(page.current_path).to eq("/login")
      end
    end
  end

  describe 'READ action' do
      context 'Index pages' do
        it 'let a logged in user view the course index page' do
          user1 = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha", :instructor => true)
          course1 = Course.create(name: "Phoenix Fundamentals", description: "Phoenix makes building robust, high-performance web applications easier and more fun than you ever thought possible.", icon: "🦅", level: 2, instructor_id: 1)
        
          user2 = User.create(:full_name => "Adri Baard", :username => "adri123",:email => "adri@example.com", :password => "stellenbosch", :instructor => false)
          course2 = Course.create(name: "Web Animation From the Experts", description: "You’ll learn everything you need to know to design and code expert level web animation through hands-on exercises and curated examples.", icon: "❤️", level: 1, instructor_id: 2)

          visit '/login'

          fill_in(:username, :with => "nili678")
          fill_in(:password, :with => "iesha")
          click_button 'Submit'

          visit "/courses"
          expect(page.body).to include(course1.name)
          expect(page.body).to include(course2.name)
        end

        it 'let a logged in user view the user index page' do
          user1 = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha", :instructor => true)
          user2 = User.create(:full_name => "Adri Baard", :username => "adri123",:email => "adri@example.com", :password => "stellenbosch", :instructor => false)
          
          visit '/login'

          fill_in(:username, :with => "nili678")
          fill_in(:password, :with => "iesha")
          click_button 'Submit'

          visit "/users"
          expect(page.body).to include(user1.full_name)
          expect(page.body).to include(user2.full_name)
        end

        it 'does not let a user view the course index if not logged in' do
          get '/courses'
          expect(last_response.location).to include("/login")
        end

        it 'does not let a user view the user index if not logged in' do
          get '/users'
          expect(last_response.location).to include("/login")
        end
      end

    context 'Individual Course page' do
      it "let a logged in user view individual course page" do
        user1 = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha", :instructor => false)
        user2 = User.create(:full_name => "Adri Baard", :username => "adri123",:email => "adri@example.com", :password => "stellenbosch", :instructor => true)
        course = Course.create(name: "Phoenix Fundamentals", description: "Phoenix makes building robust, high-performance web applications easier and more fun than you ever thought possible.", icon: "🦅", level: 2, instructor_id: 2)
        
        visit '/login'

        fill_in(:username, :with => "nili678")
        fill_in(:password, :with => "iesha")
        click_button 'Submit'
        
        visit "/courses/#{course.id}"

        expect(page.body).to include("Course information")
        expect(page.body).to include("Description")
      end

      it "let a logged in user view course enrollment status if user is a student" do
        user1 = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha", :instructor => false)
        user2 = User.create(:full_name => "Adri Baard", :username => "adri123",:email => "adri@example.com", :password => "stellenbosch", :instructor => true)
        course = Course.create(name: "Phoenix Fundamentals", description: "Phoenix makes building robust, high-performance web applications easier and more fun than you ever thought possible.", icon: "🦅", level: 2, instructor_id: 2)
        
        visit '/login'

        fill_in(:username, :with => "nili678")
        fill_in(:password, :with => "iesha")
        click_button 'Submit'
        
        visit "/courses/#{course.id}"

        expect(page.body).to include("Request to enroll in course")
      end

      it "let a logged in user view student enrollment if user is an instructor and owns course" do
        user1 = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha", :instructor => false)
        user2 = User.create(:full_name => "Adri Baard", :username => "adri123",:email => "adri@example.com", :password => "stellenbosch", :instructor => true)
        course = Course.create(name: "Phoenix Fundamentals", description: "Phoenix makes building robust, high-performance web applications easier and more fun than you ever thought possible.", icon: "🦅", level: 2, instructor_id: 2)
        
        visit '/login'

        fill_in(:username, :with => "adri123")
        fill_in(:password, :with => "stellenbosch")
        click_button 'Submit'
        
        visit "/courses/#{course.id}"

        expect(page.body).to include("Students Enrollment Status")
      end

      it "does not let a logged in user view student enrollment if user is an instructor and does not own course" do
        user1 = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha", :instructor => false)
        user2 = User.create(:full_name => "Adri Baard", :username => "adri123",:email => "adri@example.com", :password => "stellenbosch", :instructor => true)
        course = Course.create(name: "Phoenix Fundamentals", description: "Phoenix makes building robust, high-performance web applications easier and more fun than you ever thought possible.", icon: "🦅", level: 2, instructor_id: 3)
        
        visit '/login'

        fill_in(:username, :with => "adri123")
        fill_in(:password, :with => "stellenbosch")
        click_button 'Submit'
        
        visit "/courses/#{course.id}"

        expect(page.body).to include("You are not authorized")
      end

      it "does not let a user view individual course page if not logged in" do
        course = Course.create(name: "Phoenix Fundamentals", description: "Phoenix makes building robust, high-performance web applications easier and more fun than you ever thought possible.", icon: "🦅", level: 2, instructor_id: 3)
        
        visit "/courses/#{course.id}"

        expect(page.current_path).to include("/login")
      end

    end

    context 'Individual User page' do
      it "let a logged in user view an individual user's info" do
        user = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha", :instructor => false)
        user2 = User.create(:full_name => "Adri Baard", :username => "adri123",:email => "adri@example.com", :password => "stellenbosch", :instructor => true)
        
        visit '/login'

        fill_in(:username, :with => "adri123")
        fill_in(:password, :with => "stellenbosch")
        click_button 'Submit'
        
        visit "/users/#{user.id}"

        expect(page.body).to include("User information")
      end

      it "let a logged in user see a link to update their own information" do
        user = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha", :instructor => false)
        visit '/login'

        fill_in(:username, :with => "nili678")
        fill_in(:password, :with => "iesha")
        click_button 'Submit'
        
        visit "/users/#{user.id}"

        expect(page.body).to include("My account information")
      end

      it "does not let a user view individual user page if not logged in" do
        user = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha")
        
        visit "/users/#{user.id}"

        expect(page.current_path).to include("/login")
      end
    end

    context "Student's enrollment page" do
      it "let a logged in student view her course enrollment status" do
      user = User.create(:full_name => "Adri Baard", :username => "adri123",:email => "adri@example.com", :password => "stellenbosch", :instructor => false)
        
        visit '/login'

        fill_in(:username, :with => "adri123")
        fill_in(:password, :with => "stellenbosch")
        click_button 'Submit'
        
        visit "/enrolled"

        expect(page.body).to include("My enrollment list")
      end

       it "does not let a logged in instructor view course enrollment status" do
        user = User.create(:full_name => "Adri Baard", :username => "adri123",:email => "adri@example.com", :password => "stellenbosch", :instructor => true)
        
        visit '/login'

        fill_in(:username, :with => "adri123")
        fill_in(:password, :with => "stellenbosch")
        click_button 'Submit'
        
        visit "/enrolled"

        expect(page.current_path).to include("/courses")
      end

      it "does not let a user view course enrollment page if not logged in" do 
        visit "/enrolled"
        expect(page.current_path).to include("/login")
      end
    end

    context "Instructor's course page" do
      it "let a logged in instructor view her courses" do
        user = User.create(:full_name => "Adri Baard", :username => "adri123",:email => "adri@example.com", :password => "stellenbosch", :instructor => true)
        course = Course.create(name: "Phoenix Fundamentals", description: "Phoenix makes building robust, high-performance web applications easier and more fun than you ever thought possible.", icon: "🦅", level: 2, instructor_id: 1)
          
        visit '/login'

        fill_in(:username, :with => "adri123")
        fill_in(:password, :with => "stellenbosch")
        click_button 'Submit'
        
        visit "/teaching"

        expect(page.body).to include("My course list")
      end

      it "does not let a logged in student view Instructor's course page" do
        user1 = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha", :instructor => false)

        visit '/login'

        fill_in(:username, :with => "nili678")
        fill_in(:password, :with => "iesha")
        click_button 'Submit'
        
        visit "/teaching"

        expect(page.current_path).to include("/courses")
      end

      it "does not let a user view course enrollment page if not logged in" do 
        visit "/teaching"
        expect(page.current_path).to include("/login")
      end
    end
  end

  describe 'UPDATE action' do
      context 'Edit individual course page' do
        it 'let a logged in instructor edit a course if they own it' do
          user = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha", :instructor => true)
          course = Course.create(name: "Phoenix Fundamentals", description: "Phoenix makes building robust, high-performance web applications easier and more fun than you ever thought possible.", icon: "🦅", level: 2, instructor_id: 1)

          visit '/login'

          fill_in(:username, :with => "nili678")
          fill_in(:password, :with => "iesha")
          click_button 'Submit'

          visit "/courses/#{course.id}/edit"
          expect(page.body).to include("Edit course information")
        end

        it "does not let a logged in instructor edit another instructor's course" do
          user1 = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha", :instructor => true)
          course1 = Course.create(name: "Phoenix Fundamentals", description: "Phoenix makes building robust, high-performance web applications easier and more fun than you ever thought possible.", icon: "🦅", level: 2, instructor_id: 1)
        
          user2 = User.create(:full_name => "Adri Baard", :username => "adri123",:email => "adri@example.com", :password => "stellenbosch", :instructor => true)
          course2 = Course.create(name: "Web Animation From the Experts", description: "You’ll learn everything you need to know to design and code expert level web animation through hands-on exercises and curated examples.", icon: "❤️", level: 1, instructor_id: 2)

          visit '/login'

          fill_in(:username, :with => "nili678")
          fill_in(:password, :with => "iesha")
          click_button 'Submit'

          visit "/courses/#{course2.id}/edit"
          expect(page.current_path).to include("/courses/#{course2.id}")
        end

        it 'does not let a logged in student edit a course' do
          user1 = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha", :instructor => false)
          user2 = User.create(:full_name => "Adri Baard", :username => "adri123",:email => "adri@example.com", :password => "stellenbosch", :instructor => true) 
          course = Course.create(name: "Phoenix Fundamentals", description: "Phoenix makes building robust, high-performance web applications easier and more fun than you ever thought possible.", icon: "🦅", level: 2, instructor_id: 2)

          visit '/login'

          fill_in(:username, :with => "nili678")
          fill_in(:password, :with => "iesha")
          click_button 'Submit'

          visit "/courses/#{course.id}/edit"
          expect(page.current_path).to include("/courses/#{course.id}")
        end

        it 'does not let a user view Edit course page if not logged in' do
          course = Course.create(name: "Phoenix Fundamentals", description: "Phoenix makes building robust, high-performance web applications easier and more fun than you ever thought possible.", icon: "🦅", level: 2, instructor_id: 2)

          visit "/courses/#{course.id}/edit"

          expect(page.current_path).to include("/login")
        end
      end

      context 'Edit individual user page' do
        it 'let a logged in user edit user account information if it is their account' do
          user = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha", :instructor => true)

          visit '/login'

          fill_in(:username, :with => "nili678")
          fill_in(:password, :with => "iesha")
          click_button 'Submit'

          visit "/users/#{user.id}/edit"
          expect(page.body).to include("Update account information")
        end

        it 'does not let a logged in user edit user account information if it is not their account' do
          user1 = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha", :instructor => true)
          user2 = User.create(:full_name => "Adri Baard", :username => "adri123",:email => "adri@example.com", :password => "stellenbosch", :instructor => true) 
          
          visit '/login'

          fill_in(:username, :with => "nili678")
          fill_in(:password, :with => "iesha")
          click_button 'Submit'

          visit "/users/#{user2.id}"
          expect(page.body).to include("User information")
        end

        it 'does not let a user view Edit user page if not logged in' do
          user = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha", :instructor => true)
          
          visit "/users/#{user.id}/edit"

          expect(page.current_path).to include("/login")
        end
      end

      context "Edit student's enrollment page " do
        it 'let a logged in user edit course enrollment if it is her courses' do
          user = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha", :instructor => false)
          course = Course.create(name: "Phoenix Fundamentals", description: "Phoenix makes building robust, high-performance web applications easier and more fun than you ever thought possible.", icon: "🦅", level: 2, instructor_id: 2)
          new_enrollment = UserCourse.create(notes: "Please add me!", user_id: user.id, course_id: course.id)

          visit '/login'

          fill_in(:username, :with => "nili678")
          fill_in(:password, :with => "iesha")
          click_button 'Submit'

          post '/courses/:id/registration'

          visit "/update_enrollment"
          expect(page.body).to include("My enrollment list")
        end

        it 'does not let a logged in user edit course enrollment if she is not a student' do
          user = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha", :instructor => false)
          user2 = User.create(:full_name => "Adri Baard", :username => "adri123",:email => "adri@example.com", :password => "stellenbosch", :instructor => true) 
          
          course = Course.create(name: "Phoenix Fundamentals", description: "Phoenix makes building robust, high-performance web applications easier and more fun than you ever thought possible.", icon: "🦅", level: 2, instructor_id: 2)
          new_enrollment = UserCourse.create(notes: "Please add me!", user_id: user.id, course_id: course.id)

          visit '/login'

          fill_in(:username, :with => "nili678")
          fill_in(:password, :with => "iesha")
          click_button 'Submit'

          post '/courses/:id/registration'
          visit '/logout'

          visit '/login'

          fill_in(:username, :with => "adri123")
          fill_in(:password, :with => "stellenbosch")
          click_button 'Submit'

          visit "/update_enrollment"
          expect(page.current_path).to include("/courses")
        end

        it 'does not let a user view Edit student enrollment page if not logged in' do
          visit "/update_enrollment"

          expect(page.current_path).to include("/login")
        end
      end
    end

  describe 'DELETE action' do
    context "Delete user account" do
      it 'lets a logged in user delete her own account' do
        user = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha", :instructor => false)
        # user2 = User.create(:full_name => "Adri Baard", :username => "adri123",:email => "adri@example.com", :password => "stellenbosch", :instructor => true)
      
        visit '/login'

        fill_in(:username, :with => "nili678")
        fill_in(:password, :with => "iesha")
        click_button 'Submit'
        
        visit "/users/#{user.id}/edit"
        click_button "Delete My Account"
        expect(User.find_by(:id => user.id)).to eq(nil)
      end

      it "does not let a logged in user delete another user's account" do
        user = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha", :instructor => false)
        user2 = User.create(:full_name => "Adri Baard", :username => "adri123",:email => "adri@example.com", :password => "stellenbosch", :instructor => true)
      
        visit '/login'

        fill_in(:username, :with => "nili678")
        fill_in(:password, :with => "iesha")
        click_button 'Submit'
        
        visit "/users/#{user2.id}/edit"
        expect(page.current_path).to include("/users/#{user2.id}")
      end
    end

    context "Delete a course" do
      it 'lets a logged in user delete a course if she is an instructor and owns the course' do
        user = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha", :instructor => true)
        course = Course.create(name: "Phoenix Fundamentals", description: "Phoenix makes building robust, high-performance web applications easier and more fun than you ever thought possible.", icon: "🦅", level: 2, instructor_id: 1)
          
        visit '/login'

        fill_in(:username, :with => "nili678")
        fill_in(:password, :with => "iesha")
        click_button 'Submit'
        
        visit "/courses/#{course.id}/edit"
        click_button "Delete Course"
        expect(Course.find_by(:id => course.id)).to eq(nil)
      end

      it "does not let a logged in user delete another user's course" do
        user = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha", :instructor =>true)
        user2 = User.create(:full_name => "Adri Baard", :username => "adri123",:email => "adri@example.com", :password => "stellenbosch", :instructor => true)
        course = Course.create(name: "Phoenix Fundamentals", description: "Phoenix makes building robust, high-performance web applications easier and more fun than you ever thought possible.", icon: "🦅", level: 2, instructor_id: 2)
        
        visit '/login'

        fill_in(:username, :with => "nili678")
        fill_in(:password, :with => "iesha")
        click_button 'Submit'
        
        visit "/courses/#{course.id}/edit"
        expect(page.current_path).to include("/courses/#{course.id}")
      end
    end
  end
end