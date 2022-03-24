class StudentsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    def index
        students = Student.all 
        render json: students, status: :ok
    end

    def show
        student = Student.find(params[:id])
        if student
            render json: student, status: :ok
        else
            not_found
        end
    end

    def create
        student = Student.create!(student_params)
        render json: student, status: :created
    end

    def update
        student = Student.find(params[:id])
        if student
            Student.update!(student_params)
            render json: student, status: :accepted
        else 
            not_found
        end
    end

    def destroy
        student = Student.find(params[:id])
        if student
            student.destroy
            head :no_content
        else
            not_found
        end
    end

    private

    def student_params
        params.permit(:name,:major,:age,:instructor_id)
    end

    def not_found
        render json: {error: 'Student not found'}, status: :not_found
    end

    def render_unprocessable_entity_response(invalid)
        render json: { errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end
end
