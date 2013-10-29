require 'socket'
require 'colorize'
require 'readability'
require 'nokogiri'
require 'open-uri'
require 'open_uri_redirections'

require "#{Dir.home}/Desktop/Coding/textParser/app.rb"
require_relative 'ParserMemoizer'

class SocketServer
	Safari_User_Agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_4) AppleWebKit/536.30.1 (KHTML, like Gecko) Version/6.0.5 Safari/536.30.1"
	URL_REGEX       = Regexp.new("((https?|ftp|file):((//)|(\\\\))+[\w\d:\#@%/;$()~_?\+-=\\\\.&]*)")
	def initialize(opts={})
		@bank = ParserMemoizer.new :size => 30
		@port = opts[:port] || 64646
		@server = TCPServer.new @port
		loop do
			Thread.start(@server.accept) do |client|
				@input = client.gets
				if response = @bank.get(@input) then client.puts response
				else
					split_input = @input.split(" ")
					puts ["Request for \"","#{split_input.first}".green,"\""].join()
					if split_input.first.match URL_REGEX
						content = browse split_input.first, :readability => (split_input[1] and split_input[1] == "readability" ? true : false)
						parser  = Parser.new :text => content
						@bank.put @input, parser.to_json.to_s		
					else
						@bank.put @input, "Not a URL"
					end
					client.puts @bank.get(@input)
				end
				client.close
				puts "====== Done ======".green
			end
		end
	end

	def browse(url, opts={})
		puts opts
		 # user-agent prevents sites from returning 403 to real addresses.
		if opts[:readability]
			source = open(url, "User-agent" => Safari_User_Agent, :allow_redirections => :all).read
			Readability::Document.new(source).content
		else
			doc = Nokogiri::HTML(open(url, "User-agent" => Safari_User_Agent, :allow_redirections => :all))
			doc.css("p").map {|i| i.text.chomp.strip ? i.text.chomp.strip : ""}.join("\n")
		end
	end
end