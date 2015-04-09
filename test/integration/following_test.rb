require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    log_in_as(@user)
  end

  test "following page" do
  	#send get request to the named route for user followings
    get following_user_path(@user)
    #assert that the user has followings (i.e. is following at least 1 other user)
    assert_not @user.following.empty?
    #assert that the user's following count is somewhere on the page
    assert_match @user.following.count.to_s, response.body
    #for each of the followings (i.e. users being followed by our user),
    #assert that a link to that following's profile page exists
    @user.following.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end
end