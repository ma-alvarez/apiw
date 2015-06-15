class Dcv < ActiveRecord::Base
	enum status: [ :working, :ok, :error ]
end
