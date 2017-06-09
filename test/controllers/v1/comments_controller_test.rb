require 'test_helper'

module V1
  class CommentsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = create(:user)
      @comment = create(:comment, user: @user)
    end

    test "should get index" do
      get comments_url, as: :json
      assert_response :success
    end

    test "should show comment" do
      get comment_url(@comment), as: :json
      assert_response :success
    end

    # Correctly Authenticated tests
    test "should create comment when properly authenticated" do
      assert_difference('Comment.count') do
        post comments_url,
          params: { comment: { content: @comment.content, post_id: @comment.post_id } },
          headers: authenticated_header(@user), as: :json
      end
      assert_response :created
    end

    test "should update comment when properly authenticated" do
      patch comment_url(@comment),
        params: { comment: { content: @comment.content, post_id: @comment.post_id } },
        headers: authenticated_header(@user), as: :json
      assert_response :success
    end

    test "should destroy comment when properly authenticated" do
      assert_difference('Comment.count', -1) do
        delete comment_url(@comment), headers: authenticated_header(@user), as: :json
      end
      assert_response :success
    end

    # Unauthenticated Tests
    test "create should return forbidden when unauthenticated" do
      assert_difference('Comment.count', 0) do
        post comments_url,
          params: { comment: { content: @comment.content, post_id: @comment.post_id } }, as: :json
      end
      assert_response :unauthorized
    end

    test "update should return forbidden when unauthenticated" do
      patch comment_url(@comment),
        params: { comment: { content: @comment.content, post_id: @comment.post_id } }, as: :json
      assert_response :unauthorized
    end

    test "delete should return forbidden when unauthenticated" do
      assert_difference('Comment.count', 0) do
        delete comment_url(@comment), as: :json
      end
      assert_response :unauthorized
    end

    # Incorrectly Authenticated Tests
    test "should not update comment when improperly authenticated" do
      user = create(:user)
      patch comment_url(@comment),
        params: { comment: { content: @comment.content, post_id: @comment.post_id } },
        headers: authenticated_header(user), as: :json
      assert_response :forbidden
    end

    test "should not destroy comment when improperly authenticated" do
      user = create(:user)
      assert_difference('Comment.count', 0) do
        delete comment_url(@comment), headers: authenticated_header(user), as: :json
      end
      assert_response :forbidden
    end
  end
end
