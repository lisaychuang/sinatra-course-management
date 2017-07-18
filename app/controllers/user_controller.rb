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

    # Student can view courses enrolled & registration status
    get '/enrolled' do
        @enrollments = UserCourse.where(user_id: current_user.id)

        erb :"/courses/my_enrollment"
    end

    # Instructors can view courses they are teaching
    get '/teaching' do
        @courses = Course.all.map {|course|
            course.id if course.instructor_id === current_user.id}
        @my_courses = @courses.compact.map{|c| Course.find_by_id(c)}
        
        erb :"/courses/my_courses"
    end

    get "/users/:id" do 
        erb :"/users/show"
    end

    get "/users/:id/edit" do 
        erb :"/users/edit"
    end

    patch "/users/:id" do
        binding.pry
        if current_user.authenticate(params[:old_password])
            current_user.update(biography: params[:biography], email: params[:email], password: params[:new_password])
            redirect to "/users/#{current_user.id}"
        else
            redirect to "/users/#{current_user.id}/edit"
        end
    end

end