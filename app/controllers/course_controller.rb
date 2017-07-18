class CourseController < ApplicationController

    get '/courses' do
        @courses = Course.all
        @ids = @courses.map {|c| c.instructor_id}
        @hash = @ids.map {|i| User.find_by_id(i)}
        @names = @hash.map {|i| i.full_name}
        @current_user = User.find_by_id(session[:user_id])
        erb :"/courses/index"
    end

    # only instructors can create new courses
    get '/courses/new' do
        @current_user = User.find_by_id(session[:user_id])

        if @current_user.instructor 
            erb :"/courses/new"
        else
            redirect to "/courses"
        end
        
    end

    post '/courses' do

    
    end

    get '/courses/:id' do
    end


end