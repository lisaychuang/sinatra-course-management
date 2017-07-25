require 'spec_helper'

describe ApplicationController do

  describe "Homepage" do
    it 'loads the homepage' do
      get '/'
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("Training on HOT topics")
    end
  end

  describe "Signup Page" do

    it 'loads the signup page' do
      get '/signup'
      expect(last_response.status).to eq(200)
    end
    

    it 'signup directs user to Course index' do
      params = {
        :full_name => "Adri Baard",
        :username => "adri123",
        :email => "adri@example.com",
        :password => "stellenbosch"
      }
      post '/signup', params
      expect(last_response.location).to include("/courses")
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

    it 'does not let a logged in user view the signup page' do
      user = User.create(:full_name => "Adri Baard", :username => "adri123",:email => "adri@example.com", :password => "stellenbosch")
      params = {
        :full_name => "Adri Baard",
        :username => "adri123",
        :email => "adri@example.com",
        :password => "stellenbosch"
      }
      post '/signup', params
      session = {}
      session[:user_id] = user.id
      get '/signup'
      expect(last_response.location).to include('/courses')
    end
  end

  describe "login" do
    it 'loads the login page' do
      get '/login'
      expect(last_response.status).to eq(200)
    end

    it 'loads the Courses index after login' do
      user = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha")
      params = {
        :username => "nili678",
        :password => "iesha"
      }
      post '/login', params
      expect(last_response.status).to eq(302)
      follow_redirect!
      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("All Courses Available")
    end

    it 'does not let user view login page if already logged in' do
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

  describe "logout" do
    it "lets a user logout if they are already logged in" do
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

    it 'does not load /Courses if user not logged in' do
      get '/courses'
      expect(last_response.location).to include("/login")
    end

    it 'does load /courses if user is logged in' do
      user = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha")
      visit '/login'

      fill_in(:username, :with => "nili678")
      fill_in(:password, :with => "iesha")
      click_button 'Submit'
      expect(page.current_path).to eq('/courses')
    end
  end

  describe 'Course show page' do
    it "shows a single course's details" do
      user = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha")
      course = Course.create(name: "Phoenix Fundamentals", description: "Phoenix makes building robust, high-performance web applications easier and more fun than you ever thought possible.", icon: "🦅", level: 2, instructor_id: 1)
      
      get "/courses/#{course.id}"

      expect(last_response.body).to include("Course information")
      expect(last_response.body).to include("Description")

    end
  end

  describe 'index action' do
    context 'logged in' do
      it 'lets a user view the course index if logged in' do
        user = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha")
        course1 = Course.create(name: "Phoenix Fundamentals", description: "Phoenix makes building robust, high-performance web applications easier and more fun than you ever thought possible.", icon: "🦅", level: 2, instructor_id: 1)
      
        user2 = User.create(:full_name => "Adri Baard", :username => "adri123",:email => "adri@example.com", :password => "stellenbosch")
        course2 = Course.create(name: "Web Animation From the Experts", description: "You’ll learn everything you need to know to design and code expert level web animation through hands-on exercises and curated examples.", icon: "❤️", level: 1, instructor_id: 2)


        visit '/login'

        fill_in(:username, :with => "nili678")
        fill_in(:password, :with => "iesha")
        click_button 'Submit'
        visit "/courses"
        expect(page.body).to include(course1.name)
        expect(page.body).to include(course2.name)
      end
    end

    context 'logged out' do
      it 'does not let a user view the Course index if not logged in' do
        get '/courses'
        expect(last_response.location).to include("/login")
      end
    end
  end

  describe 'new action' do
    context 'logged in' do
      it 'lets user view new Course form if logged in and is an instructor' do
        user = User.create(:full_name => "Nili Ach", :username => "nili678",:email => "niliach@example.com", :password => "iesha")

        visit '/login'

        fill_in(:username, :with => "nili678")
        fill_in(:password, :with => "iesha")
        click_button 'Submit'
        visit '/courses/new'
        expect(page.status_code).to eq(200)
      end

      it 'lets user create a course if they are logged in and is an instructor' do
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

      it 'does not let a user create a blank course' do
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
    end

    context 'logged out' do
      it 'does not let user view new course form if not logged in' do
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
end

  # describe 'show action' do
  #   context 'logged in' do
  #     it 'displays a single tweet' do

  #       user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
  #       tweet = Tweet.create(:content => "i am a boss at tweeting", :user_id => user.id)

  #       visit '/login'

  #       fill_in(:username, :with => "becky567")
  #       fill_in(:password, :with => "kittens")
  #       click_button 'submit'

  #       visit "/tweets/#{tweet.id}"
  #       expect(page.status_code).to eq(200)
  #       expect(page.body).to include("Delete Tweet")
  #       expect(page.body).to include(tweet.content)
  #       expect(page.body).to include("Edit Tweet")
  #     end
  #   end

  #   context 'logged out' do
  #     it 'does not let a user view a tweet' do
  #       user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
  #       tweet = Tweet.create(:content => "i am a boss at tweeting", :user_id => user.id)
  #       get "/tweets/#{tweet.id}"
  #       expect(last_response.location).to include("/login")
  #     end
  #   end
  # end

  # describe 'edit action' do
  #   context "logged in" do
  #     it 'lets a user view tweet edit form if they are logged in' do
  #       user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
  #       tweet = Tweet.create(:content => "tweeting!", :user_id => user.id)
  #       visit '/login'

  #       fill_in(:username, :with => "becky567")
  #       fill_in(:password, :with => "kittens")
  #       click_button 'submit'
  #       visit '/tweets/1/edit'
  #       expect(page.status_code).to eq(200)
  #       expect(page.body).to include(tweet.content)
  #     end

  #     it 'does not let a user edit a tweet they did not create' do
  #       user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
  #       tweet1 = Tweet.create(:content => "tweeting!", :user_id => user1.id)

  #       user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
  #       tweet2 = Tweet.create(:content => "look at this tweet", :user_id => user2.id)

  #       visit '/login'

  #       fill_in(:username, :with => "becky567")
  #       fill_in(:password, :with => "kittens")
  #       click_button 'submit'
  #       session = {}
  #       session[:user_id] = user1.id
  #       visit "/tweets/#{tweet2.id}/edit"
  #       expect(page.current_path).to include('/tweets')
  #     end

  #     it 'lets a user edit their own tweet if they are logged in' do
  #       user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
  #       tweet = Tweet.create(:content => "tweeting!", :user_id => 1)
  #       visit '/login'

  #       fill_in(:username, :with => "becky567")
  #       fill_in(:password, :with => "kittens")
  #       click_button 'submit'
  #       visit '/tweets/1/edit'

  #       fill_in(:content, :with => "i love tweeting")

  #       click_button 'submit'
  #       expect(Tweet.find_by(:content => "i love tweeting")).to be_instance_of(Tweet)
  #       expect(Tweet.find_by(:content => "tweeting!")).to eq(nil)
  #       expect(page.status_code).to eq(200)
  #     end

  #     it 'does not let a user edit a text with blank content' do
  #       user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
  #       tweet = Tweet.create(:content => "tweeting!", :user_id => 1)
  #       visit '/login'

  #       fill_in(:username, :with => "becky567")
  #       fill_in(:password, :with => "kittens")
  #       click_button 'submit'
  #       visit '/tweets/1/edit'

  #       fill_in(:content, :with => "")

  #       click_button 'submit'
  #       expect(Tweet.find_by(:content => "i love tweeting")).to be(nil)
  #       expect(page.current_path).to eq("/tweets/1/edit")
  #     end
  #   end

  #   context "logged out" do
  #     it 'does not load let user view tweet edit form if not logged in' do
  #       get '/tweets/1/edit'
  #       expect(last_response.location).to include("/login")
  #     end
  #   end
  # end

  # describe 'delete action' do
  #   context "logged in" do
  #     it 'lets a user delete their own tweet if they are logged in' do
  #       user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
  #       tweet = Tweet.create(:content => "tweeting!", :user_id => 1)
  #       visit '/login'

  #       fill_in(:username, :with => "becky567")
  #       fill_in(:password, :with => "kittens")
  #       click_button 'submit'
  #       visit 'tweets/1'
  #       click_button "Delete Tweet"
  #       expect(page.status_code).to eq(200)
  #       expect(Tweet.find_by(:content => "tweeting!")).to eq(nil)
  #     end

  #     it 'does not let a user delete a tweet they did not create' do
  #       user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
  #       tweet1 = Tweet.create(:content => "tweeting!", :user_id => user1.id)

  #       user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
  #       tweet2 = Tweet.create(:content => "look at this tweet", :user_id => user2.id)

  #       visit '/login'

  #       fill_in(:username, :with => "becky567")
  #       fill_in(:password, :with => "kittens")
  #       click_button 'submit'
  #       visit "tweets/#{tweet2.id}"
  #       click_button "Delete Tweet"
  #       expect(page.status_code).to eq(200)
  #       expect(Tweet.find_by(:content => "look at this tweet")).to be_instance_of(Tweet)
  #       expect(page.current_path).to include('/tweets')
  #     end
  #   end

  #   context "logged out" do
  #     it 'does not load let user delete a tweet if not logged in' do
  #       tweet = Tweet.create(:content => "tweeting!", :user_id => 1)
  #       visit '/tweets/1'
  #       expect(page.current_path).to eq("/login")
  #     end
  #   end
  # end
# end
