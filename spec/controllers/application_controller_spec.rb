require 'spec_helper'

describe ApplicationController do

  # describe "Homepage" do
  #   it 'loads the homepage' do
  #     get '/'
  #     expect(last_response.status).to eq(200)
  #     expect(last_response.body).to include("Welcome to Fwitter")
  #   end
  # end

  # describe "Signup Page" do

  #   it 'loads the signup page' do
  #     get '/signup'
  #     expect(last_response.status).to eq(200)
  #   end

  #   it 'signup directs user to twitter index' do
  #     params = {
  #       :username => "skittles123",
  #       :email => "skittles@aol.com",
  #       :password => "rainbows"
  #     }
  #     post '/signup', params
  #     expect(last_response.location).to include("/tweets")
  #   end

  #   it 'does not let a user sign up without a username' do
  #     params = {
  #       :username => "",
  #       :email => "skittles@aol.com",
  #       :password => "rainbows"
  #     }
  #     post '/signup', params
  #     expect(last_response.location).to include('/signup')
  #   end

  #   it 'does not let a user sign up without an email' do
  #     params = {
  #       :username => "skittles123",
  #       :email => "",
  #       :password => "rainbows"
  #     }
  #     post '/signup', params
  #     expect(last_response.location).to include('/signup')
  #   end

  #   it 'does not let a user sign up without a password' do
  #     params = {
  #       :username => "skittles123",
  #       :email => "skittles@aol.com",
  #       :password => ""
  #     }
  #     post '/signup', params
  #     expect(last_response.location).to include('/signup')
  #   end

  #   it 'does not let a logged in user view the signup page' do
  #     user = User.create(:username => "skittles123", :email => "skittles@aol.com", :password => "rainbows")
  #     params = {
  #       :username => "skittles123",
  #       :email => "skittles@aol.com",
  #       :password => "rainbows"
  #     }
  #     post '/signup', params
  #     session = {}
  #     session[:user_id] = user.id
  #     get '/signup'
  #     expect(last_response.location).to include('/tweets')
  #   end
  # end

  # describe "login" do
  #   it 'loads the login page' do
  #     get '/login'
  #     expect(last_response.status).to eq(200)
  #   end

  #   it 'loads the tweets index after login' do
  #     user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
  #     params = {
  #       :username => "becky567",
  #       :password => "kittens"
  #     }
  #     post '/login', params
  #     expect(last_response.status).to eq(302)
  #     follow_redirect!
  #     expect(last_response.status).to eq(200)
  #     expect(last_response.body).to include("Welcome,")
  #   end

  #   it 'does not let user view login page if already logged in' do
  #     user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

  #     params = {
  #       :username => "becky567",
  #       :password => "kittens"
  #     }
  #     post '/login', params
  #     session = {}
  #     session[:user_id] = user.id
  #     get '/login'
  #     expect(last_response.location).to include("/tweets")
  #   end
  # end

  # describe "logout" do
  #   it "lets a user logout if they are already logged in" do
  #     user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

  #     params = {
  #       :username => "becky567",
  #       :password => "kittens"
  #     }
  #     post '/login', params
  #     get '/logout'
  #     expect(last_response.location).to include("/login")
  #   end

  #   it 'does not let a user logout if not logged in' do
  #     get '/logout'
  #     expect(last_response.location).to include("/")
  #   end

  #   it 'does not load /tweets if user not logged in' do
  #     get '/tweets'
  #     expect(last_response.location).to include("/login")
  #   end

  #   it 'does load /tweets if user is logged in' do
  #     user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")


  #     visit '/login'

  #     fill_in(:username, :with => "becky567")
  #     fill_in(:password, :with => "kittens")
  #     click_button 'submit'
  #     expect(page.current_path).to eq('/tweets')
  #   end
  # end

  # describe 'user show page' do
  #   it 'shows all a single users tweets' do
  #     user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
  #     tweet1 = Tweet.create(:content => "tweeting!", :user_id => user.id)
  #     tweet2 = Tweet.create(:content => "tweet tweet tweet", :user_id => user.id)
  #     get "/users/#{user.slug}"

  #     expect(last_response.body).to include("tweeting!")
  #     expect(last_response.body).to include("tweet tweet tweet")

  #   end
  # end

  # describe 'index action' do
  #   context 'logged in' do
  #     it 'lets a user view the tweets index if logged in' do
  #       user1 = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
  #       tweet1 = Tweet.create(:content => "tweeting!", :user_id => user1.id)

  #       user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")
  #       tweet2 = Tweet.create(:content => "look at this tweet", :user_id => user2.id)

  #       visit '/login'

  #       fill_in(:username, :with => "becky567")
  #       fill_in(:password, :with => "kittens")
  #       click_button 'submit'
  #       visit "/tweets"
  #       expect(page.body).to include(tweet1.content)
  #       expect(page.body).to include(tweet2.content)
  #     end
  #   end

  #   context 'logged out' do
  #     it 'does not let a user view the tweets index if not logged in' do
  #       get '/tweets'
  #       expect(last_response.location).to include("/login")
  #     end
  #   end
  # end

  # describe 'new action' do
  #   context 'logged in' do
  #     it 'lets user view new tweet form if logged in' do
  #       user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

  #       visit '/login'

  #       fill_in(:username, :with => "becky567")
  #       fill_in(:password, :with => "kittens")
  #       click_button 'submit'
  #       visit '/tweets/new'
  #       expect(page.status_code).to eq(200)
  #     end

  #     it 'lets user create a tweet if they are logged in' do
  #       user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

  #       visit '/login'

  #       fill_in(:username, :with => "becky567")
  #       fill_in(:password, :with => "kittens")
  #       click_button 'submit'

  #       visit '/tweets/new'
  #       fill_in(:content, :with => "tweet!!!")
  #       click_button 'submit'

  #       user = User.find_by(:username => "becky567")
  #       tweet = Tweet.find_by(:content => "tweet!!!")
  #       expect(tweet).to be_instance_of(Tweet)
  #       expect(tweet.user_id).to eq(user.id)
  #       expect(page.status_code).to eq(200)
  #     end

  #     it 'does not let a user tweet from another user' do
  #       user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
  #       user2 = User.create(:username => "silverstallion", :email => "silver@aol.com", :password => "horses")

  #       visit '/login'

  #       fill_in(:username, :with => "becky567")
  #       fill_in(:password, :with => "kittens")
  #       click_button 'submit'

  #       visit '/tweets/new'

  #       fill_in(:content, :with => "tweet!!!")
  #       click_button 'submit'

  #       user = User.find_by(:id=> user.id)
  #       user2 = User.find_by(:id => user2.id)
  #       tweet = Tweet.find_by(:content => "tweet!!!")
  #       expect(tweet).to be_instance_of(Tweet)
  #       expect(tweet.user_id).to eq(user.id)
  #       expect(tweet.user_id).not_to eq(user2.id)
  #     end

  #     it 'does not let a user create a blank tweet' do
  #       user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

  #       visit '/login'

  #       fill_in(:username, :with => "becky567")
  #       fill_in(:password, :with => "kittens")
  #       click_button 'submit'

  #       visit '/tweets/new'

  #       fill_in(:content, :with => "")
  #       click_button 'submit'

  #       expect(Tweet.find_by(:content => "")).to eq(nil)
  #       expect(page.current_path).to eq("/tweets/new")
  #     end
  #   end

  #   context 'logged out' do
  #     it 'does not let user view new tweet form if not logged in' do
  #       get '/tweets/new'
  #       expect(last_response.location).to include("/login")
  #     end
  #   end
  # end

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
end
