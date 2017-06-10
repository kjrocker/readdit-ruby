module V1
  class VotesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = create(:user)
      @post = create(:post, user: @user)
      @comment = create(:comment, user: @user, post: @post)
    end

    test "should create vote" do
      assert_difference('Vote.count') do
        post post_vote_url(@post), params: { vote: { value: 1 } },
          headers: authenticated_header(@user), as: :json
      end
      assert_response :created
    end

    test "should destroy vote" do
      post post_vote_url(@post), params: { vote: { value: 1 } },
        headers: authenticated_header(@user), as: :json
      assert_difference('Vote.count', -1) do
        delete post_vote_url(@post), headers: authenticated_header(@user), as: :json
      end
      assert_response :success
    end

    # Unauthenticated Tests
    test "should not create vote" do
      assert_difference('Vote.count', 0) do
        post post_vote_url(@post), params: { vote: { value: 1 } }, as: :json
      end
      assert_response :unauthorized
    end

    test "should not destroy vote" do
      assert_difference('Vote.count', 0) do
        delete post_vote_url(@post), as: :json
      end
      assert_response :unauthorized
    end
  end
end
