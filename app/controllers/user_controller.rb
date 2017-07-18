class UserController < ApplicationController
  
    get '/signup' do
        if logged_in?
            redirect to "/courses"
        else
            erb :"/users/new"
        end
    end

    post '/signup' do
        @user = User.create(full_name: params[:full_name], username: params[:username], email: params[:email], password: params[:password])
        @user.instructor = true if params[:instructor] == "yes"

        if @user.save
            session[:user_id] = @user.id
            redirect to "/courses"
        else
            redirect to "/signup"
        end
    end

    get '/login' do
        if logged_in?
            redirect to "/courses"
        else
            erb :"/users/login"
        end
    end

    post '/login' do
        @user = User.find_by(username: params[:username])

        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            redirect to "/courses"
        else
            redirect to "/login"
        end
    end

    get '/logout' do
        if logged_in?
            session.clear
            redirect to "/login"
        else
            redirect to "/"
        end
    end

    # Student can view courses enrolled & their status
    get '/enrolled' do

        erb :"/courses/my_enrollment"
    end

    # Instructors can view courses they are teaching
    get '/teaching' do
        @current_user = User.find_by_id(session[:user_id])
        @courses = Course.all.map {|course|
            course.id if course.instructor_id === @current_user.id}
        @my_courses = @courses.compact.map{|c| Course.find_by_id(c)}
        
        erb :"/courses/my_courses"
    end

    get "/users/:slug" do 
        @user = User.find_by_slug(params[:slug])
        
        # if user is an instructor
            # display courses_teaching
            # include DELETE button to delete course
        #else
            #display courses_registered
            # include DELETE button to delete course



        erb :"/users/show"
    end



end