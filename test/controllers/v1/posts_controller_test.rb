require 'test_helper'

module V1
  class PostsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = create(:user)
      @post = create(:post, user: @user)
    end

    test "should get index" do
      get posts_url, as: :json
      assert_response :success
    end

    test "should create post" do
      assert_difference('Post.count') do
        post posts_url,
          params: { post: { content: @post.content, title: @post.title } },
          headers: authenticated_header(@user), as: :json
      end
      assert_response 201
    end

    test "should show post" do
      get post_url(@post), as: :json
      assert_response :success
    end

    test "should update post" do
      patch post_url(@post),
        params: { post: { content: @post.content, title: @post.title } },
        headers: authenticated_header(@user), as: :json
      assert_response 200
    end

    test "should destroy post" do
      assert_difference('Post.count', -1) do
        delete post_url(@post), headers: authenticated_header(@user), as: :json
      end
      assert_response 204
    end

    # Unauthenticated Tests
    test "create should return forbidden when unauthenticated" do
      assert_difference('Post.count', 0) do
        post posts_url,
          params: { post: { content: @post.content, title: @post.title } }, as: :json
      end
      assert_response :unauthorized
    end

    test "update should return forbidden when unauthenticated" do
      patch post_url(@post),
        params: { post: { content: @post.content, title: @post.title } }, as: :json
      assert_response :unauthorized
    end

    test "delete should return forbidden when unauthenticated" do
      assert_difference('Post.count', 0) do
        delete post_url(@post), as: :json
      end
      assert_response :unauthorized
    end

    # Incorrectly Authenticated Tests
    test "should not update post when improperly authenticated" do
      user = create(:user)
      patch post_url(@post),
        params: { post: { content: @post.content, title: @post.title } },
        headers: authenticated_header(user), as: :json
      assert_response :forbidden
    end

    test "should not destroy post when improperly authenticated" do
      user = create(:user)
      assert_difference('Post.count', 0) do
        delete post_url(@post), headers: authenticated_header(user), as: :json
      end
      assert_response :forbidden
    end
  end
end
