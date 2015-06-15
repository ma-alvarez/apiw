class User < ActiveRecord::Base
	validates :username, presence:true
	validates :username, uniqueness:true
	validates :admin, :inclusion => {:in => [true, false]}
end
