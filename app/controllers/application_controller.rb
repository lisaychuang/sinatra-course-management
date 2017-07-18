require './config/environment'

class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  enable :sessions

  set :session_secret, "secret_courses"
  set :views, Proc.new { File.join(root, "../views/") }

  use Rack::Flash
  
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

    def course_difficulty(num)
        if num === 0
          "Easy"
        elsif num === 1
          "Intermediate"
        else
          "Hard"
        end
    end

    def registration_status(num)
        if num === 0
          "Pending"
        elsif num === 1
          "Waitlisted"
        else
          "Enrolled"
        end
    end
    
    def find_course(id)
      Course.find_by_id(id)
    end
  end

end