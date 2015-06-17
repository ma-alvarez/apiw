class Status < ActiveRecord::Base
	enum status: [ :working, :ok, :error ]
end
