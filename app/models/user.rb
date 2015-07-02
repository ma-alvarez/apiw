class User < ActiveRecord::Base
	validates :username,:email,:password, presence:true
	validates :username,:email, uniqueness:true

	def as_json(options = {})
		super(only:[:id,:email,:username,:admin])
	end
end
