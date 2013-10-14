# A simple applet for creating a JSON semantic vector for a URL
# using a socket on port 64646
# @author= Jonathan Raiman
# @date= October 2013

require_relative 'classes/SocketServer'

if __FILE__ == $0
	server = SocketServer.new(:port => 64646)
end