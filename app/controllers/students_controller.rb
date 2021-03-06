class StudentsController < ApplicationController

    before_action :authorized

    def index
    end

    def my_track
      @student = Student.find(params[:id])
      @required_prof_courses = ProfessorCourse.select do |prof_cou|
        prof_cou.course.majors.include?(@student.major) && !prof_cou.student_professor_courses.map(&:student).include?(@student)
      end
      render :my_track
    end

    def my_courses
      @student = Student.find(params[:id])
      render :my_courses
    end

    def show
        @student = Student.find(params[:id])
    end

    def add_course
      # @professor = ProfessorCourse.find(params[:professor_course_id]).professor
      @student = Student.find(params[:id])
      # if !@student.professor_courses.map(&:professor).include?(@professor)
      #   StudentProfessorCourse.create(student_id: params[:id], professor_course_id: params[:professor_course_id], grade: "")
      # else
      #   flash[:errors] = ["You've already taken or are currently enrolled in this course."]
      # end

      course = ProfessorCourse.find(params[:professor_course_id]).course

      el = StudentProfessorCourse.all.find do |stu_prof_cou|
        stu_prof_cou.professor_course.course == course
      end

      if !el
        StudentProfessorCourse.create(student_id: params[:id], professor_course_id: params[:professor_course_id], grade: "")
      else
        flash[:errors] = ["You've already taken or are currently enrolled in this course."]
      end
      redirect_to my_track_path(params[:id])

    end
    
    def bio
      @professor = Professor.find(params[:id])
      render "/professors/#{@professor.id}/bio"
    end

    def authorized
      if session[:user_id]
        if session[:position] == "professor"
          redirect_to professor_path(session[:user_id])
        elsif session[:user_id] != params[:id]
          redirect_to student_path(session[:user_id])
        end
      else
        redirect_to login_path
      end
    end
end
