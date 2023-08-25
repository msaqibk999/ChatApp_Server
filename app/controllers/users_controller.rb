class UsersController < ApplicationController
    def create_or_find_user
      user = User.find_by(phone_number: params[:phone_number])
  
      if user
        render json: user, status: :ok
      else
        new_user = User.create(phone_number: params[:phone_number])
        if new_user.save
          render json: new_user, status: :created
        else
          render json: new_user.errors, status: :unprocessable_entity
        end
      end
    end

    def update_token
        user = User.find_by(phone_number: params[:phone_number])
    
        if user
          if user.update(token: params[:token])
            render json: { message: 'Token updated successfully' }
          else
            render json: { error: 'Token update failed' }, status: :unprocessable_entity
          end
        else
          render json: { error: 'User not found with the provided phone number' }, status: :not_found
        end
      end

      def delete_token
        user = User.find_by(phone_number: params[:phone_number])
    
        if user
          if user.update(token: nil)
            render json: { message: 'Token deleted successfully' }
          else
            render json: { error: 'Token deletion failed' }, status: :unprocessable_entity
          end
        else
          render json: { error: 'User not found with the provided phone number' }, status: :not_found
        end
      end

  end
  