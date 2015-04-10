class Relationship < ActiveRecord::Base
	# We declare in the User model that the foreign key for the active_relationships
	# association is :follower_id, so we need to declare the corresponding association
	# on the Relationship model side (belongs_to a follower (fk = follower_id)) which we lookup
	# in the User class.
	belongs_to :follower, class_name: "User"
	belongs_to :followed, class_name: "User"
	validates :follower_id, presence: true
	validates :followed_id, presence: true
end