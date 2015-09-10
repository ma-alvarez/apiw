set :stage, :production

# Replace 127.0.0.1 with your server's IP address!
server '10.120.164.2', user: 'malvarez', roles: %w{web app db}
server '10.120.164.3', user: 'malvarez', roles: %w{web app }