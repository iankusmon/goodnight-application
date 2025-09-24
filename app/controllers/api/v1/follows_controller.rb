module Api
  module V1
    class FollowsController < ApplicationController
      def create
        follow = Follow.new(follower_id: params[:user_id], followed_id: params[:followed_id])
        if follow.save
          render json: follow, status: :created
        else
          render json: { errors: follow.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        follow = Follow.find_by(follower_id: params[:user_id], followed_id: params[:id])
        if follow
          follow.destroy
          head :no_content
        else
          head :not_found
        end
      end
    end
  end
end
