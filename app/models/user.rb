class User < ActiveRecord::Base
	validates :username,:admin, presence:true
	validates :username, uniqueness:true
end
