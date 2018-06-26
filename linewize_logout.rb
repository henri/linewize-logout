#!//usr/bin/env ruby
#
# (C) 2018 Henri Shustak
# Released under the GNU GPL v3 or later
#
# About this Script : 
# Attempts to logout from the linewiz
#
# Version 1.1

def logout_from_linewize
  `curl -L "http://autologout.linewize.net/" 2> /dev/null`
  
  # the DNS flushing seems to cause issues with network homes and Safari
  #`sudo killall -HUP mDNSResponder`
  #`sudo killall -HUP mDNSResponderHelper`
  #`sudo dscacheutil -flushcache`
end


logout_from_linewize

