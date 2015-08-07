module ActiveDirectory

  DOMAIN_CONTROLLER = "int.fibercorp.com.ar"
  LDAP_PORT = "389"
  VRA_BASE = "OU=Clientes Externos,OU=vRealize Automation,DC=int,DC=fibercorp,DC=com,DC=ar"
  BASE = "DC=int,DC=fibercorp,DC=com,DC=ar"	
  USERNAME = "app_apiw"
  PASSWORD = "fcQmuSQngeZo6CywpR6v"
  ADS_UF_ACCOUNTDISABLE = 0x00000002

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
    attributes = ["dn", "givenName", "memberOf", "userAccountControl"]
  	filter = Net::LDAP::Filter.eq("givenName", givenName)
	  result = @ldap.search(:base => treebase, :filter => filter, :attributes => attributes) { |item|  
	   return item  		
    }  
  end

  def self.query_by_ou(treebase,organizational_unit)
    attributes = ["dn", "ou"]
    filter = Net::LDAP::Filter.eq("ou", organizational_unit)
    result = @ldap.search(:base => treebase, :filter => filter, :attributes => attributes) { |item|
      return item
    }
  end

  def self.disable_user(givenName)
    result = query_by_given_name(ActiveDirectory::BASE,givenName)
    dn = result.dn
    user_account_control = (result.userAccountControl.first.to_i | ADS_UF_ACCOUNTDISABLE)
    @ldap.replace_attribute dn, "userAccountControl", user_account_control.to_s
  end

  def self.enable_user(givenName)
    result = query_by_given_name(ActiveDirectory::BASE,givenName)
    dn = result.dn
    user_account_control = (result.userAccountControl.first.to_i ^ ADS_UF_ACCOUNTDISABLE)
    @ldap.replace_attribute dn, "userAccountControl", user_account_control.to_s
  end

  def self.remove_ou(ou)
    result = query_by_ou(ActiveDirectory::BASE,ou)
    dn = result.dn
    @ldap.delete :dn => dn
  end

  def self.user_exists?(treebase,givenName)
    return !ActiveDirectory.query_by_given_name(treebase,givenName).empty?
  end

  def self.change_permissions(givenName,clientName)
    result = query_by_given_name(ActiveDirectory::VRA_BASE,givenName)
    dn_user = result.dn
    actual_group = result.memberOf.first
    if !actual_group[clientName].nil?
      new_group = change_group(actual_group)
      @ldap.add_attribute(new_group, "member", dn_user)
      ops = [
        [:delete, :member, dn_user]
      ]
      @ldap.modify :dn => actual_group, :operations => ops
    end
  end

  def self.remove_user(givenName)
    result = query_by_given_name(ActiveDirectory::BASE,givenName)
    dn = result.dn
    @ldap.delete :dn => dn
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