class InstructorsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    def index
        instructors = Instructor.all 
        render json: instructors, status: :ok
    end

    def show
        instructor = Instructor.find(params[:id])
        if instructor
            render json: instructor, status: :ok
        else
            not_found
        end
    end

    def create
        instructor = Instructor.create!(instructor_params)
        render json: instructor, status: :created
    end

    def update
        instructor = Instructor.find(params[:id])
        if instructor
            Instructor.update!(instructor_params)
            render json: instructor, status: :accepted
        else 
            not_found
        end
    end

    def destroy
        instructor = Instructor.find(params[:id])
        if instructor
            instructor.destroy
            head :no_content
        else
            not_found
        end
    end

    private

    def instructor_params
        params.permit(:name)
    end

    def not_found
        render json: {error: 'Instructor not found'}, status: :not_found
    end

    def render_unprocessable_entity_response(invalid)
        render json: { errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end
end
