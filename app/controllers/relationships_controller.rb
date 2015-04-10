class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    # The unfollow partial searches for a specific Relationship,
    # so in our destroy action we look up that particular relationship
    # by its id and then return the user object w/ matching the followed_id.
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      # For non-JS-enabled browsers, simply redirect to the user profile page.
      format.html { redirect_to @user }
      # For JS-enabled browsers, render the contents of destroy.js.erb
      # to update the button to the Follow button and decrement the follower count
      # of the user whose profile page we are on.
      format.js 
    end
  end
end