module ActiveDirectory

  DOMAIN_CONTROLLER = "int.fibercorp.com.ar"
  LDAP_PORT = "389"
  BASE = "OU=Clientes Externos,DC=int,DC=fibercorp,DC=com,DC=ar"
  TREEBASE = "OU=Clientes Externos,OU=vRealize Automation,DC=int,DC=fibercorp,DC=com,DC=ar"	
  USERNAME = "app_apiw"
  PASSWORD = "fcQmuSQngeZo6CywpR6v"

  def self.connect
    @ldap = Net::LDAP.new  :host => DOMAIN_CONTROLLER, # your LDAP host name or IP goes here,
		                          :port => LDAP_PORT, # your LDAP host port goes here,
		                          :base => BASE, # the base of your AD tree goes here,
		                          :auth => {
		                        :method => :simple,
		                        :username => USERNAME, # a user w/sufficient privileges to read from AD goes here,
		                        :password => PASSWORD # the user's password goes here
    }
  end

  def self.connection_ok?
	 @ldap.bind
  end

  def self.query_by_given_name(treebase,givenName)
  	filter = Net::LDAP::Filter.eq("givenName", givenName)
	  result = @ldap.search(:base => treebase, :filter => filter)
	  return result 		
  end

  def self.user_exists?(treebase,givenName)
    return !ActiveDirectory.query_by_given_name(treebase,givenName).empty?
  end

end