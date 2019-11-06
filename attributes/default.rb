#
# Cookbook:: holmes-users
# Attributes:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

default['holmes-users']['setup_ssh?'] = false
default['holmes-users']['data_bag'].tap do |db|
  db['users'] = 'users'
  db['groups'] = 'groups'
  db['credentials'] = 'credentials'
end

# Main SSH options
default['holmes-users']['ssh_config']['main'].tap do |ssh|
  ssh['ForwardAgent'] = 'no'
  ssh['ForwardX11'] = 'no'
  ssh['RhostsRSAAuthentication'] = 'no'
  ssh['RSAAuthentication'] = 'yes'
  ssh['PasswordAuthentication'] = 'no'
  ssh['HostbasedAuthentication'] = 'no'
  ssh['GSSAPIAuthentication'] = 'no'
  ssh['GSSAPIDelegateCredentials'] = 'no'
  ssh['GSSAPIKeyExchange'] = 'no'
  ssh['GSSAPITrustDNS'] = 'no'
  ssh['BatchMode'] = 'no'
  ssh['CheckHostIP'] = 'yes'
  ssh['AddressFamily'] = 'any'
  ssh['PermitLocalCommand'] = 'no'
  ssh['VisualHostKey'] = 'no'
  ssh['Tunnel'] = 'no'
  ssh['GSSAPIAuthentication'] = 'yes'
  ssh['ForwardX11Trusted'] = 'yes'
end
default['holmes-users']['ssh_config']['other'].tap do |ssh|
  ssh['ConnectTimeout'] = '0'
  ssh['StrictHostKeyChecking'] = 'ask'
  ssh['Port'] = '22'
  ssh['Protocol'] = '2'
  ssh['Cipher'] = '3des'
  ssh['Ciphers'] = 'aes128-ctr,aes192-ctr,aes256-ctr,arcfour256,arcfour128,aes128-cbc,3des-cbc'
  ssh['MACs'] = 'hmac-md5,hmac-sha1,umac-64@openssh.com,hmac-ripemd160'
  ssh['EscapeChar'] = '~'
  ssh['TunnelDevice'] = 'any:any'
  ssh['ProxyCommand'] = 'ssh -q -W %h:%p gateway.example.com'
  ssh['RekeyLimit'] = '1G 1h'
end
