class CourseController < ApplicationController
    
    # View all courses
    get '/courses' do
        @courses = Course.all
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
        binding.pry
        @course_enrollment = UserCourse.where(course_id: params[:id])

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

    # Instructor can EDIT a course information
    get '/courses/:id/edit' do
        @course = find_course(params[:id])
        if current_user.instructor && current_user.id === @course.instructor.id
            erb :"/courses/edit_course"
        else
            redirect to "/courses/#{@course.id}"
        end
    end

    # UPDATE course based on form input
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

    # Instructor can DELETE their own courses
    delete '/courses/:id' do
        @course = find_course(params[:id])
        if current_user.id === @course.instructor.id
            @course.destroy
            redirect to "/teaching"
        else
            redirect to "/courses"
        end
    end

    # UPDATE Student course registration
    post '/courses/:id/registration' do
        @course = find_course(params[:id])
        @new_enrollment = UserCourse.create(notes: params[:notes], user_id: current_user.id, course_id: params[:id])
        @new_enrollment.save

        redirect to "/courses/#{@course.id}"
    end

end