module V1
  class VotesController < ApplicationController
    before_action :authenticate_user
    before_action :set_vote


    def create
      @vote.update(vote_params)
      render json: {}, status: :created
    end

    def destroy
      @vote.destroy if @vote.persisted?
    end

    private

      def set_vote
        klass = params[:post_id].present? ? Post : Comment
        id = params[:post_id].present? ? params[:post_id] : params[:comment_id]
        votable = klass.find(id)
        @vote = Vote.find_or_initialize_by(votable: votable, user: current_user)
      end

      def vote_params
        params.require(:vote).permit(:value)
      end
  end
end
