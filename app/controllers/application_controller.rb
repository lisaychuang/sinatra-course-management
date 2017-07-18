require './config/environment'

class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  enable :sessions

  set :session_secret, "secret_courses"
  set :views, Proc.new { File.join(root, "../views/") }

  get '/' do
    erb :index
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end
    
    def current_user
      User.find_by_id(session[:user_id])
    end

    def instructor_name(id)
        binding.pry
        @instructor = User.find_by_id(id)
        @instructor.full_name
    end
    
  end

end