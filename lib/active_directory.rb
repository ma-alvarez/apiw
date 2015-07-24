module ActiveDirectory

  DOMAIN_CONTROLLER = "int.fibercorp.com.ar"
  LDAP_PORT = "389"
  VRA_BASE = "OU=Clientes Externos,OU=vRealize Automation,DC=int,DC=fibercorp,DC=com,DC=ar"
  BASE = "DC=int,DC=fibercorp,DC=com,DC=ar"	
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
    attributes = ["dn", "givenName", "memberOf"]
  	filter = Net::LDAP::Filter.eq("givenName", givenName)
	  result = @ldap.search(:base => treebase, :filter => filter, :attributes => attributes) { |item|  
	   return item  		
    }  
  end

  def self.user_exists?(treebase,givenName)
    return !ActiveDirectory.query_by_given_name(treebase,givenName).empty?
  end

  def self.change_permissions(givenName)
    result = query_by_given_name(ActiveDirectory::VRA_BASE,givenName)
    dn_user = result.dn
    actual_group = result.memberOf.first
    new_group = change_group(actual_group)
    @ldap.add_attribute(new_group, "member", dn_user)
    ops = [
      [:delete, :member, dn_user]
    ]
    @ldap.modify :dn => actual_group, :operations => ops
  end

  private
    def self.change_group(dn_group)
      if !dn_group["-Support"].nil?
        dn_group.gsub("Support", "Users")
      elsif !dn_group["-Users"].nil?
        dn_group.gsub("Users","Support")
      end
    end

end