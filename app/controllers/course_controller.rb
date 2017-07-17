class CourseController < ApplicationController

    get '/courses' do
        @courses = Course.all
        erb :"/courses/index"
    end

    get '/courses/new' do

        erb :"/courses/new"
    end


end