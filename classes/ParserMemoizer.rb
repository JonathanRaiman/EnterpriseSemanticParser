class ParserMemoizer

	def initialize(opts={})
		@bank = {}
		@max_bank_size = opts[:size] || 50
		@keys = []
	end

	def put key, value
		if @keys.length >= @max_bank_size
			old_key = @keys.shift
			@bank.delete(old_key)
		end
		@bank[key] = value
		@keys -= [key]
		@keys << key
	end

	def get key
		@bank[key]
	end

	def flush
		@keys = []
		@bank = {}
	end

end