class CourseController < ApplicationController
    
    # View all courses
    get '/courses' do
        @courses = Course.all
        @current_user = current_user
        
        erb :"/courses/index"
    end

    # only instructors can view form to create a new course
    get '/courses/new' do
        if current_user.instructor 
            erb :"/courses/new"
        else
            redirect to "/courses"
        end
    end

    # Instructor CREATE a new course
    post '/courses' do
        @new_course = Course.create(name: params[:name], icon: params[:icon], description: params[:descrciption], level: params[:level].to_i-1, instructor_id: session[:user_id])
        @new_course.save
        redirect to "/courses"
    end

    # View a single course page
    get '/courses/:id' do
        @course = find_course(params[:id])
        @existing_registration = nil
        if !current_user.instructor
            @existing_registration = UserCourse.where("course_id = ? AND user_id = ?", params[:id], current_user.id).first
        end
        
        if logged_in?
            erb :"/courses/show"
        else
            redirect to "/login"
        end
    end

    get '/courses/:id/edit' do
        @course = find_course(params[:id])
        erb :"/courses/edit"
    end

    patch '/courses/:id' do
        @course = find_course(params[:id])
        @course.update(name: params[:name], icon: params[:icon], description: params[:description], level: params[:level].to_i-1)

        if current_user.instructor && current_user.id === @course.instructor.id
            if @course.save
                flash[:message] = "Successfully edited course."
                redirect to "/courses/#{@course.id}"
            else 
                flash[:message] = "Something went wrong. Please try to edit course again."
                redirect to "/courses/#{@course.id}/edit"
            end
        else
            redirect to "/courses/#{@course.id}"
        end
    end

    post '/courses/:id/registration' do
        @course = Course.find_by_id(params[:id])
        @new_enrollment = UserCourse.create(notes: params[:notes], user_id: current_user.id, course_id: params[:id])
        @new_enrollment.save

        redirect to "/courses/#{@course.id}"
    end

end