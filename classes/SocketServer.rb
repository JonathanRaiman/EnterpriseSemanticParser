require 'socket'
require 'colorize'
require 'readability'
require 'open-uri'

source = open('http://lab.arc90.com/experiments/readability/').read
require "#{Dir.home}/Desktop/Coding/textParser/app.rb"

class SocketServer
	URL_REGEX = Regexp.new("((https?|ftp|file):((//)|(\\\\))+[\w\d:\#@%/;$()~_?\+-=\\\\.&]*)")
	def initialize(opts={})
		@port = opts[:port] || 64646
		@server = TCPServer.new @port
		loop do
			Thread.start(@server.accept) do |client|
				@input = client.gets
				puts "Request for #{@input}".green
				if @input.match URL_REGEX
					content = browse @input
					parser  = Parser.new :text => content
					client.puts parser.to_json.to_s
				else
					client.puts "Not a URL"
				end
				client.close
			end
		end
	end

	def browse url
		source = open(url).read
		Readability::Document.new(source).content
	end
end